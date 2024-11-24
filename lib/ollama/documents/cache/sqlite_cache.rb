require 'ollama/documents/cache/common'
require 'sqlite3'
require 'sqlite_vec'
require 'digest/md5'

class Ollama::Documents::Cache::SQLiteCache
  include Ollama::Documents::Cache::Common

  def initialize(prefix:, embedding_length: 1_024, filename: ':memory:', debug: false)
    super(prefix:)
    @embedding_length = embedding_length
    @filename         = filename
    @debug            = debug
    setup_database(filename)
  end

  attr_reader :filename # filename for the database, `:memory:` is in memory

  attr_reader :embedding_length # length of the embeddings vector

  def [](key)
    result = execute(
      %{
        SELECT records.key, records.text, records.norm, records.source,
          records.tags, embeddings.embedding
        FROM records
        INNER JOIN embeddings ON records.embedding_id = embeddings.rowid
        WHERE records.key = ?
      },
      pre(key)
    )&.first or return
    key, text, norm, source, tags, embedding = *result
    embedding = embedding.unpack("f*")
    tags      = Ollama::Utils::Tags.new(JSON(tags.to_s).to_a, source:)
    convert_value_to_record(key:, text:, norm:, source:, tags:, embedding:)
  end

  def []=(key, value)
    value = convert_value_to_record(value)
    embedding = value.embedding.pack("f*")
    execute(%{BEGIN})
    execute(%{INSERT INTO embeddings(embedding) VALUES(?)}, [ embedding ])
    embedding_id, = execute(%{ SELECT last_insert_rowid() }).flatten
    execute(%{
      INSERT INTO records(key,text,embedding_id,norm,source,tags)
      VALUES(?,?,?,?,?,?)
    }, [ pre(key), value.text, embedding_id, value.norm, value.source, JSON(value.tags) ])
    execute(%{COMMIT})
  end

  def key?(key)
    execute(
      %{ SELECT count(records.key) FROM records WHERE records.key = ? },
      pre(key)
    ).flatten.first == 1
  end

  def delete(key)
    result = key?(key) ? pre(key) : nil
    execute(
      %{ DELETE FROM records WHERE records.key = ? },
      pre(key)
    )
    result
  end

  def tags
    result = Ollama::Utils::Tags.new
    execute(%{
        SELECT DISTINCT(tags) FROM records WHERE key LIKE ?
      }, [ "#@prefix%" ]
    ).flatten.each do
      JSON(_1).each { |t| result.add(t) }
    end
    result
  end

  def size
    execute(%{SELECT COUNT(*) FROM records WHERE key LIKE ?}, [ "#@prefix%" ]).flatten.first
  end

  def clear_for_tags(tags = nil)
    tags = Ollama::Utils::Tags.new(tags).to_a
    if tags.present?
      records = find_records_for_tags(tags)
      keys = '(%s)' % records.transpose.first.map { "'%s'" % quote(_1) }.join(?,)
      execute(%{DELETE FROM records WHERE key IN #{keys}})
    else
      clear
    end
    self
  end

  def clear
    execute(%{DELETE FROM records WHERE key LIKE ?}, [ "#@prefix%" ])
    self
  end

  def each(prefix: "#@prefix%", &block)
    execute(%{
      SELECT records.key, records.text, records.norm, records.source,
        records.tags, embeddings.embedding
      FROM records
      INNER JOIN embeddings ON records.embedding_id = embeddings.rowid
      WHERE records.key LIKE ?
    }, [ prefix ]).each do |key, text, norm, source, tags, embedding|
      embedding = embedding.unpack("f*")
      tags      = Ollama::Utils::Tags.new(JSON(tags.to_s).to_a, source:)
      value     = convert_value_to_record(key:, text:, norm:, source:, tags:, embedding:)
      block.(key, value)
    end
  end
  include Enumerable

  def full_each(&block)
    each(prefix: ?%, &block)
  end

  def convert_to_vector(vector)
    vector
  end

  def find_records_for_tags(tags)
    if tags.present?
      tags_filter = Ollama::Utils::Tags.new(tags).to_a
      unless  tags_filter.empty?
        tags_where  = ' AND (%s)' % tags_filter.map {
          'tags LIKE "%%%s%%"' % quote(_1)
        }.join(' OR ')
      end
    end
    records = execute(%{
      SELECT key, tags, embedding_id
      FROM records
      WHERE key LIKE ?#{tags_where}
    }, [ "#@prefix%" ])
    if tags_filter
      records = records.select { |key, tags, embedding_id|
        (tags_filter & JSON(tags.to_s).to_a).size >= 1
      }
    end
    records
  end

  def find_records(needle, tags: nil, max_records: nil)
    needle.size != @embedding_length and
      raise ArgumentError, "needle embedding length != %s" % @embedding_length
    needle_binary = needle.pack("f*")
    max_records   = [ max_records, size, 4_096 ].compact.min
    records = find_records_for_tags(tags)
    rowids_where = '(%s)' % records.transpose.last&.join(?,)
    execute(%{
      SELECT records.key, records.text, records.norm, records.source,
        records.tags, embeddings.embedding
      FROM records
      INNER JOIN embeddings ON records.embedding_id = embeddings.rowid
      WHERE embeddings.rowid IN #{rowids_where}
        AND embeddings.embedding MATCH ? AND embeddings.k = ?
    }, [ needle_binary, max_records ]).map do |key, text, norm, source, tags, embedding|
      key       = unpre(key)
      embedding = embedding.unpack("f*")
      tags      = Ollama::Utils::Tags.new(JSON(tags.to_s).to_a, source:)
      convert_value_to_record(key:, text:, norm:, source:, tags:, embedding:)
    end
  end

  private

  def execute(*a)
    if @debug
      e = a[0].gsub(/^\s*\n/, '')
      e = e.gsub(/\A\s+/, '')
      n = $&.to_s.size
      e = e.gsub(/^\s{0,#{n}}/, '')
      e = e.chomp
      STDERR.puts("EXPLANATION:\n%s\n%s" % [
        e,
        @database.execute("EXPLAIN #{e}", *a[1..-1]).pretty_inspect
      ])
    end
    @database.execute(*a)
  end

  def quote(string)
    SQLite3::Database.quote(string)
  end

  def setup_database(filename)
    @database = SQLite3::Database.new(filename)
    @database.enable_load_extension(true)
    SqliteVec.load(@database)
    @database.enable_load_extension(false)
    execute %{
      CREATE VIRTUAL TABLE IF NOT EXISTS embeddings USING vec0(
        embedding float[#@embedding_length]
      )
    }
    execute %{
      CREATE TABLE IF NOT EXISTS records (
        key          text NOT NULL PRIMARY KEY ON CONFLICT REPLACE,
        text         text NOT NULL DEFAULT '',
        embedding_id integer,
        norm         float NOT NULL DEFAULT 0.0,
        source       text,
        tags         json NOT NULL DEFAULT [],
        FOREIGN KEY(embedding_id) REFERENCES embeddings(id) ON DELETE CASCADE
      )
    }
  end

  def convert_value_to_record(value)
    value.is_a?(Ollama::Documents::Record) and return value
    Ollama::Documents::Record[value.to_hash]
  end
end

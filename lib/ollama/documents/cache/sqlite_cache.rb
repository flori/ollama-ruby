require 'ollama/documents/cache/common'
require 'sqlite3'
require 'sqlite_vec'
require 'digest/md5'

class Ollama::Documents::Cache::SQLiteCache
  include Ollama::Documents::Cache::Common

  def initialize(prefix:, embedding_length: 1_024, filename: ':memory:')
    super(prefix:)
    @embedding_length = embedding_length
    @filename         = filename
    @database         = setup_database(filename)
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

  def size
    execute(%{SELECT COUNT(*) FROM records WHERE key LIKE ?}, [ "#@prefix%" ]).flatten.first
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
    each(prefix: '', &block)
  end

  def convert_to_vector(vector)
    vector
  end

  # Do you have any improvements for this method:
  def find_records(needle, tags: nil, max_records: nil)
    max_records = [ max_records, size, 4_096 ].compact.min
    needle.size != @embedding_length and
      raise ArgumentError, "needle embedding length != %s" % @embedding_length
    needle_binary = needle.pack("f*")
    tags_filter = tags
    tags_where = 'true'
    if tags_filter
      tags_filter = Ollama::Utils::Tags.new(tags_filter).to_a
      unless  tags_filter.empty?
        tags_where  = '(%s)' % tags_filter.map { 'tags LIKE "%%%s%%"' % quote(_1) }.join(' OR ')
      end
    end
    keys = execute(%{
      SELECT key, tags, embedding_id
      FROM records
      WHERE key LIKE ? AND #{tags_where}
    }, [ "#@prefix%" ])
    if tags_filter
      keys = keys.select { |key, tags, embedding_id| (tags_filter & JSON(tags.to_s).to_a).size >= 1 }
    end
    rowids_where = '(%s)' % keys.transpose.last&.join(?,)
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
    @database.execute(*a)
  end

  def quote(string)
    SQLite3::Database.quote(string)
  end

  def setup_database(filename)
    database = SQLite3::Database.new(filename)
    database.enable_load_extension(true)
    SqliteVec.load(database)
    database.enable_load_extension(false)
    database.execute %{
      CREATE VIRTUAL TABLE IF NOT EXISTS embeddings USING vec0(
        embedding float[#@embedding_length]
      )
    }
    database.execute %{
      CREATE TABLE IF NOT EXISTS records (
        key          text,
        text         text,
        embedding_id integer,
        norm         float,
        source       text,
        tags         json,
        FOREIGN KEY(embedding_id) REFERENCES embeddings(id) ON DELETE CASCADE
      )
    }
    database
  end

  def convert_value_to_record(value)
    value.is_a?(Ollama::Documents::Record) and return value
    Ollama::Documents::Record[value.to_hash]
  end
end

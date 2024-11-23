require 'numo/narray'
require 'digest'
require 'kramdown/ansi'

class Ollama::Documents
end
module Ollama::Documents::Cache
end
require 'ollama/documents/cache/records'
require 'ollama/documents/cache/memory_cache'
require 'ollama/documents/cache/redis_cache'
require 'ollama/documents/cache/redis_backed_memory_cache'
require 'ollama/documents/cache/sqlite_cache'
module Ollama::Documents::Splitters
end
require 'ollama/documents/splitters/character'
require 'ollama/documents/splitters/semantic'

class Ollama::Documents
  include Kramdown::ANSI::Width
  include Ollama::Documents::Cache

  class Record < JSON::GenericObject
    def to_s
      my_tags = tags_set
      my_tags.empty? or my_tags = " #{my_tags}"
      "#<#{self.class} #{text.inspect}#{my_tags} #{similarity || 'n/a'}>"
    end

    def tags_set
      Ollama::Utils::Tags.new(tags, source:)
    end

    def ==(other)
      text == other.text
    end

    alias inspect to_s
  end

  def initialize(ollama:, model:, model_options: nil, collection: nil, embedding_length: 1_024, cache: MemoryCache, database_filename: nil, redis_url: nil, debug: false)
    collection ||= default_collection
    @ollama, @model, @model_options, @collection =
      ollama, model, model_options, collection.to_sym
    database_filename ||= ':memory:'
    @cache = connect_cache(cache, redis_url, embedding_length, database_filename)
    @debug = debug
  end

  def default_collection
    :default
  end

  attr_reader :ollama, :model, :collection, :cache

  def collection=(new_collection)
    @collection   = new_collection.to_sym
    @cache.prefix = prefix
  end

  def add(inputs, batch_size: nil, source: nil, tags: [])
    inputs = Array(inputs)
    batch_size ||= 10
    tags = Ollama::Utils::Tags.new(tags, source:)
    if source
      tags.add(File.basename(source).gsub(/\?.*/, ''), source:)
    end
    inputs.map! { |i|
      text = i.respond_to?(:read) ? i.read : i.to_s
      text
    }
    inputs.reject! { |i| exist?(i) }
    inputs.empty? and return self
    if @debug
      puts Ollama::Utils::ColorizeTexts.new(inputs)
    end
    batches = inputs.each_slice(batch_size).
      with_infobar(
        label: "Add #{truncate(tags.to_s(link: false), percentage: 25)}",
        total: inputs.size
      )
    batches.each do |batch|
      embeddings = fetch_embeddings(model:, options: @model_options, input: batch)
      batch.zip(embeddings) do |text, embedding|
        norm       = @cache.norm(embedding)
        self[text] = Record[text:, embedding:, norm:, source:, tags: tags.to_a]
      end
      infobar.progress by: batch.size
    end
    infobar.newline
    self
  end
  alias << add

  def [](text)
    @cache[key(text)]
  end

  def []=(text, record)
    @cache[key(text)] = record
  end

  def exist?(text)
    @cache.key?(key(text))
  end

  def delete(text)
    @cache.delete(key(text))
  end

  def size
    @cache.size
  end

  def clear(tags: nil)
    @cache.clear(tags:)
    self
  end

  def find(string, tags: nil, prompt: nil, max_records: nil)
    needle = convert_to_vector(string, prompt:)
    @cache.find_records(needle, tags:, max_records: nil)
  end

  def find_where(string, text_size: nil, text_count: nil, **opts)
    if text_count
      opts[:max_records] =  text_count
    end
    records = find(string, **opts)
    size, count = 0, 0
    records.take_while do |record|
      if text_size and (size += record.text.size) > text_size
        next false
      end
      if text_count and (count += 1) > text_count
        next false
      end
      true
    end
  end

  def collections
    ([ default_collection ] + @cache.collections('%s-' % self.class)).uniq
  end

  def tags
    @cache.tags
  end

  private

  def connect_cache(cache_class, redis_url, embedding_length, database_filename)
    cache = nil
    if (cache_class.instance_method(:redis) rescue nil)
      begin
        cache = cache_class.new(prefix:, url: redis_url, object_class: Record)
        cache.size
      rescue Redis::CannotConnectError
        STDERR.puts(
          "Cannot connect to redis URL #{redis_url.inspect}, "\
          "falling back to MemoryCache."
        )
      end
    elsif cache_class == SQLiteCache
      cache = cache_class.new(prefix:, embedding_length:, filename: database_filename) # TODO filename
    end
  ensure
    cache ||= MemoryCache.new(prefix:,)
    cache.respond_to?(:find_records) or cache.extend(Records::FindRecords)
    cache.extend(Records::Tags)
    if cache.respond_to?(:redis) # TODO check this
      cache.extend(Records::RedisFullEach)
    end
    return cache
  end

  def convert_to_vector(input, prompt: nil)
    if prompt
      input = prompt % input
    end
    input.is_a?(String) and input = fetch_embeddings(model:, input:).first
    @cache.convert_to_vector(input)
  end

  def fetch_embeddings(model:, input:, options: nil)
    @ollama.embed(model:, input:, options:).embeddings
  end

  def prefix
    '%s-%s-' % [ self.class, @collection ]
  end

  def key(input)
    Digest::SHA256.hexdigest(input)
  end
end

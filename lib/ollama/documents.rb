require 'numo/narray'
require 'digest'

class Ollama::Documents
end
require 'ollama/documents/memory_cache'
require 'ollama/documents/redis_cache'
module Ollama::Documents::Splitters
end
require 'ollama/documents/splitters/character'
require 'ollama/documents/splitters/semantic'

class Ollama::Documents
  include Ollama::Utils::Math

  class Record < JSON::GenericObject
    def to_s
      my_tags = Ollama::Utils::Tags.new(tags)
      my_tags.empty? or my_tags = " #{my_tags}"
      "#<#{self.class} #{text.inspect}#{my_tags} #{similarity || 'n/a'}>"
    end

    def ==(other)
      text == other.text
    end

    alias inspect to_s
  end

  def initialize(ollama:, model:, model_options: nil, collection: :default, cache: MemoryCache, redis_url: nil)
    @ollama, @model, @model_options, @collection = ollama, model, model_options, collection
    @cache, @redis_url = connect_cache(cache), redis_url
  end

  attr_reader :ollama, :model, :collection

  def collection=(new_collection)
    @collection = new_collection
    @cache.prefix = prefix
  end

  def add(inputs, batch_size: 10, source: nil, tags: [])
    inputs = Array(inputs)
    tags   = Ollama::Utils::Tags.new(tags)
    source and tags.add File.basename(source)
    inputs.map! { |i|
      text = i.respond_to?(:read) ? i.read : i.to_s
      text
    }
    inputs.reject! { |i| exist?(i) }
    inputs.empty? and return self
    batches = inputs.each_slice(batch_size).
      with_infobar(
        label: "Add #{tags}",
        total: inputs.size
      )
    batches.each do |batch|
      embeddings = fetch_embeddings(model:, options: @model_options, input: batch)
      batch.zip(embeddings) do |text, embedding|
        norm       = norm(embedding)
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
    if tags
      tags = Ollama::Utils::Tags.new(Array(tags)).to_a
      @cache.each do |key, record|
        if (tags & record.tags).size >= 1
          @cache.delete(@cache.unpre(key))
        end
      end
    else
      @cache.clear
    end
    self
  end

  def find(string, tags: nil, prompt: nil)
    needle      = convert_to_vector(string, prompt:)
    needle_norm = norm(needle)
    records = @cache
    if tags
      tags = Ollama::Utils::Tags.new(tags).to_a
      records = records.select { |_key, record| (tags & record.tags).size >= 1 }
    end
    records = records.sort_by { |key, record|
      record.key        = key
      record.similarity = cosine_similarity(
        a: needle,
        b: record.embedding,
        a_norm: needle_norm,
        b_norm: record.norm,
      )
    }
    records.transpose.last&.reverse.to_a
  end

  def collections
    case @cache
    when MemoryCache
      [ @collection ]
    when RedisCache
      prefix = '%s-' % self.class
      Documents::RedisCache.new(prefix:, url: @redis_url).map { _1[/#{prefix}(.*)-/, 1] }.uniq
    else
      []
    end
  end

  def tags
    @cache.inject(Ollama::Utils::Tags.new) { |t, (_, record)| t.merge(record.tags) }
  end

  private

  def connect_cache(cache_class)
    cache = nil
    if cache_class == RedisCache
      begin
        cache = cache_class.new(prefix:)
        cache.size
      rescue Redis::CannotConnectError
        STDERR.puts(
          "Cannot connect to redis URL #{@redis_url.inspect}, "\
          "falling back to MemoryCache."
        )
      end
    end
  ensure
    cache ||= MemoryCache.new(prefix:)
    return cache
  end

  def convert_to_vector(input, prompt: nil)
    if prompt
      input = prompt % input
    end
    if input.is_a?(String)
      Numo::NArray[*fetch_embeddings(model:, input:).first]
    else
      super(input)
    end
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

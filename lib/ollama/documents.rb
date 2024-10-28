require 'numo/narray'
require 'digest'

class Ollama::Documents
end
class Ollama::Documents::Cache
end
require 'ollama/documents/cache/memory_cache'
require 'ollama/documents/cache/redis_cache'
require 'ollama/documents/cache/redis_backed_memory_cache'
module Ollama::Documents::Splitters
end
require 'ollama/documents/splitters/character'
require 'ollama/documents/splitters/semantic'

class Ollama::Documents
  include Ollama::Utils::Width

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

  def initialize(ollama:, model:, model_options: nil, collection: nil, cache: MemoryCache, redis_url: nil, debug: false)
    collection ||= default_collection
    @ollama, @model, @model_options, @collection =
      ollama, model, model_options, collection.to_sym
    @redis_url = redis_url
    @cache     = connect_cache(cache)
    @debug     = debug
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
    needle_norm = @cache.norm(needle)
    records = @cache
    if tags
      tags = Ollama::Utils::Tags.new(tags).to_a
      records = records.select { |_key, record| (tags & record.tags).size >= 1 }
    end
    records = records.sort_by { |key, record|
      record.key        = key
      record.similarity = @cache.cosine_similarity(
        a: needle,
        b: record.embedding,
        a_norm: needle_norm,
        b_norm: record.norm,
      )
    }
    records.transpose.last&.reverse.to_a
  end

  def find_where(string, text_size: nil, text_count: nil, **opts)
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
    @cache.each_with_object(Ollama::Utils::Tags.new) do |(_, record), t|
      record.tags.each do |tag|
        t.add(tag, source: record.source)
      end
    end
  end

  private

  def connect_cache(cache_class)
    cache = nil
    if cache_class.instance_method(:redis)
      begin
        cache = cache_class.new(prefix:, url: @redis_url, object_class: Record)
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

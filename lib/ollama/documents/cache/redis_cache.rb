require 'ollama/documents/cache/common'
require 'redis'

class Ollama::Documents::RedisCache
  include Ollama::Documents::Cache::Common

  def initialize(prefix:, url: ENV['REDIS_URL'], object_class: nil, ex: nil)
    super(prefix:)
    url or raise ArgumentError, 'require redis url'
    @url, @object_class, @ex = url, object_class, ex
  end

  attr_reader :object_class

  def redis
    @redis ||= Redis.new(url: @url)
  end

  def [](key)
    value = redis.get(pre(key))
    unless value.nil?
      object_class ? JSON(value, object_class:) : JSON(value)
    end
  end

  def []=(key, value)
    set(key, value)
  end

  def set(key, value, ex: nil)
    ex ||= @ex
    if !ex.nil? && ex < 1
      redis.del(pre(key))
    else
      redis.set(pre(key), JSON.generate(value), ex:)
    end
    value
  end

  def ttl(key)
    redis.ttl(pre(key))
  end

  def key?(key)
    !!redis.exists?(pre(key))
  end

  def delete(key)
    redis.del(pre(key)) == 1
  end

  def size
    s = 0
    redis.scan_each(match: "#@prefix*") { |key| s += 1 }
    s
  end

  def clear
    redis.scan_each(match: "#@prefix*") { |key| redis.del(key) }
    self
  end

  def each(&block)
    redis.scan_each(match: "#@prefix*") { |key| block.(key, self[unpre(key)]) }
    self
  end
  include Enumerable
end

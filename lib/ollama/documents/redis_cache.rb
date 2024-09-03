require 'redis'

class Ollama::Documents::RedisCache
  def initialize(prefix:, url: ENV['REDIS_URL'])
    url or raise ArgumentError, 'require redis url'
    @prefix, @url = prefix, url
  end

  attr_writer :prefix

  def redis
    @redis ||= Redis.new(url: @url)
  end

  def [](key)
    value = redis.get(pre(key))
    unless value.nil?
      JSON(value, object_class: Ollama::Documents::Record)
    end
  end

  def []=(key, value)
    redis.set(pre(key), JSON(value))
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

  def pre(key)
    [ @prefix, key ].join
  end

  def unpre(key)
    key.sub(/\A#@prefix/, '')
  end
end

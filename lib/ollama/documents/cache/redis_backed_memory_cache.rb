require 'redis'

class Ollama::Documents
  class RedisBackedMemoryCache < MemoryCache
    def initialize(prefix:, url: ENV['REDIS_URL'])
      super(prefix:)
      url or raise ArgumentError, 'require redis url'
      @prefix, @url = prefix, url
      @redis_cache  = Ollama::Documents::RedisCache.new(prefix:, url:)
      @redis_cache.full_each do |key, value|
        @data[key] = value
      end
    end

    def redis
      @redis_cache.redis
    end

    def []=(key, value)
      super
      redis.set(pre(key), JSON(value))
    end

    def delete(key)
      result = redis.del(pre(key))
      super
      result
    end

    def clear
      redis.scan_each(match: "#@prefix*") { |key| redis.del(key) }
      super
      self
    end
  end
end

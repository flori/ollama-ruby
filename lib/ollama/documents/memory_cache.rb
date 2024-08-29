class Ollama::Documents::MemoryCache
  def initialize(prefix:)
    @prefix = prefix
    @data   = {}
  end

  attr_writer :prefix

  def [](key)
    @data[pre(key)]
  end

  def []=(key, value)
    @data[pre(key)] = value
  end

  def key?(key)
    @data.key?(pre(key))
  end

  def delete(key)
    @data.delete(pre(key))
  end

  def size
    @data.size
  end

  def clear
    @data.clear
    self
  end

  def each(&block)
    @data.select { |key,| key.start_with?(@prefix) }.each(&block)
  end
  include Enumerable

  private

  def pre(key)
    [ @prefix, key ].join
  end
end

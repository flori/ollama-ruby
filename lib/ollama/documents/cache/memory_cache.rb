require 'ollama/documents/cache/common'

class Ollama::Documents::MemoryCache
  include Ollama::Documents::Cache::Common

  def initialize(prefix:)
    super(prefix:)
    @data   = {}
  end

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
    count
  end

  def clear
    @data.delete_if { |key, _| key.start_with?(@prefix) }
    self
  end

  def each(&block)
    @data.select { |key,| key.start_with?(@prefix) }.each(&block)
  end
  include Enumerable

  def full_each(&block)
    @data.each(&block)
  end
end

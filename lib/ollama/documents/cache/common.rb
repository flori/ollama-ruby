module Ollama::Documents::Cache::Common
  include Ollama::Utils::Math

  attr_writer :prefix

  def collections(prefix)
    unique = Set.new
    full_each { |key, _| unique << key[/\A#{prefix}(.*)-/, 1] }
    unique.map(&:to_sym)
  end

  def pre(key)
    [ @prefix, key ].join
  end

  def unpre(key)
    key.sub(/\A#@prefix/, '')
  end
end

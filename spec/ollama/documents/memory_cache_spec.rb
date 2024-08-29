require 'spec_helper'

RSpec.describe Ollama::Documents::MemoryCache do
  let :memory_cache do
    described_class.new prefix: 'test-'
  end

  it 'can be instantiated' do
    expect(memory_cache).to be_a described_class
  end

  it 'can get/set a key' do
    key, value = 'foo', { test: true }
    expect {
      memory_cache[key] = value
    }.to change {
      memory_cache[key]
    }.from(nil).to(value)
  end

  it 'can determine if key exists' do
    key, value = 'foo', { test: true }
    expect {
      memory_cache[key] = value
    }.to change {
      memory_cache.key?(key)
    }.from(false).to(true)
  end

  it 'can delete' do
    key, value = 'foo', { test: true }
    memory_cache[key] = value
    expect {
      memory_cache.delete(key)
    }.to change {
      memory_cache.key?(key)
    }.from(true).to(false)
  end

  it 'returns size' do
    key, value = 'foo', { test: true }
    expect {
      memory_cache[key] = value
    }.to change {
      memory_cache.size
    }.from(0).to(1)
  end

  it 'can clear' do
    key, value = 'foo', { test: true }
    memory_cache[key] = value
    expect {
      expect(memory_cache.clear).to eq memory_cache
    }.to change {
      memory_cache.size
    }.from(1).to(0)
  end

  it 'can iterate over keys under a prefix' do
    memory_cache['foo'] = 'bar'
    expect(memory_cache.to_a).to eq [ %w[ test-foo bar ] ]
  end
end

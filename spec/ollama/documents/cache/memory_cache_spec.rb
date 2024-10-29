require 'spec_helper'

RSpec.describe Ollama::Documents::MemoryCache do
  let :cache do
    described_class.new prefix: 'test-'
  end

  it 'can be instantiated' do
    expect(cache).to be_a described_class
  end

  it 'can get/set a key' do
    key, value = 'foo', { test: true }
    expect {
      cache[key] = value
    }.to change {
      cache[key]
    }.from(nil).to(value)
  end

  it 'can determine if key exists' do
    key, value = 'foo', { test: true }
    expect {
      cache[key] = value
    }.to change {
      cache.key?(key)
    }.from(false).to(true)
  end

  it 'can delete' do
    key, value = 'foo', { test: true }
    cache[key] = value
    expect {
      cache.delete(key)
    }.to change {
      cache.key?(key)
    }.from(true).to(false)
  end

  it 'returns size' do
    key, value = 'foo', { test: true }
    expect {
      cache[key] = value
    }.to change {
      cache.size
    }.from(0).to(1)
  end

  it 'can clear' do
    key, value = 'foo', { test: true }
    cache[key] = value
    expect {
      expect(cache.clear).to eq cache
    }.to change {
      cache.size
    }.from(1).to(0)
  end

  it 'can iterate over keys under a prefix' do
    cache['foo'] = 'bar'
    expect(cache.to_a).to eq [ %w[ test-foo bar ] ]
  end
end

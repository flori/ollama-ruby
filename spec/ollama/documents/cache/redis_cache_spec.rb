require 'spec_helper'

RSpec.describe Ollama::Documents::RedisCache do
  it 'can be instantiated' do
    cache = described_class.new prefix: 'test-', url: 'something'
    expect(cache).to be_a described_class
  end

  it 'defaults to nil object_class' do
    cache = described_class.new prefix: 'test-', url: 'something'
    expect(cache.object_class).to be_nil
  end

  it 'can be configured with object_class' do
    object_class = Class.new(JSON::GenericObject)
    cache = described_class.new(prefix: 'test-', url: 'something', object_class:)
    expect(cache.object_class).to eq object_class
  end

  it 'raises ArgumentError if url is missing' do
    expect {
      described_class.new prefix: 'test-', url: nil
    }.to raise_error ArgumentError
  end

  context 'test redis interactions' do
    let :cache do
      described_class.new prefix: 'test-', url: 'something'
    end

    let :redis do
      double('Redis')
    end

    before do
      allow_any_instance_of(described_class).to receive(:redis).and_return(redis)
    end

    it 'has Redis client' do
      expect(cache.redis).to eq redis
    end

    it 'can get a key' do
      key = 'foo'
      expect(redis).to receive(:get).with('test-' + key).and_return '"some_json"'
      expect(cache[key]).to eq 'some_json'
    end

    it 'can set a value for a key' do
      key, value = 'foo', { test: true }
      expect(redis).to receive(:set).with('test-' + key, JSON(value), ex: nil)
      cache[key] = value
    end

    it 'can set a value for a key with ttl' do
      cache = described_class.new prefix: 'test-', url: 'something', ex: 3_600
      key, value = 'foo', { test: true }
      expect(redis).to receive(:set).with('test-' + key, JSON(value), ex: 3_600)
      cache[key] = value
      expect(redis).to receive(:ttl).with('test-' + key).and_return 3_600
      expect(cache.ttl(key)).to eq 3_600
    end

    it 'can determine if key exists' do
      key = 'foo'
      expect(redis).to receive(:exists?).with('test-' + key).and_return(false, true)
      expect(cache.key?('foo')).to eq false
      expect(cache.key?('foo')).to eq true
    end

    it 'can delete' do
      key = 'foo'
      expect(redis).to receive(:del).with('test-' + key)
      cache.delete(key)
    end

    it 'returns size' do
      allow(redis).to receive(:scan_each).with(match: 'test-*').
        and_yield('test-foo').
        and_yield('test-bar').
        and_yield('test-baz')
      expect(cache.size).to eq 3
    end

    it 'can clear' do
      expect(redis).to receive(:scan_each).with(match: 'test-*').and_yield(
        'test-foo'
      )
      expect(redis).to receive(:del).with('test-foo')
      expect(cache.clear).to eq cache
    end

    it 'can iterate over keys under a prefix' do
      expect(redis).to receive(:scan_each).with(match: 'test-*')
      cache.to_a
    end

    it 'can compute prefix with pre' do
      expect(cache.pre('foo')).to eq 'test-foo'
    end

    it 'can remove prefix with unpre' do
      expect(cache.unpre('test-foo')).to eq 'foo'
    end
  end
end

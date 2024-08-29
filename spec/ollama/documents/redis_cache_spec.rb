require 'spec_helper'

RSpec.describe Ollama::Documents::RedisCache do
  it 'can be instantiated' do
    redis_cache = described_class.new prefix: 'test-', url: 'something'
    expect(redis_cache).to be_a described_class
  end

  it 'raises ArgumentError if url is missing' do
    expect {
      described_class.new prefix: 'test-', url: nil
    }.to raise_error ArgumentError
  end

  context 'test redis interactions' do
    let :redis_cache do
      described_class.new prefix: 'test-', url: 'something'
    end

    let :redis do
      double('Redis')
    end

    before do
      allow_any_instance_of(described_class).to receive(:redis).and_return(redis)
    end

    it 'has Redis client' do
      expect(redis_cache.redis).to eq redis
    end

    it 'can get a key' do
      key = 'foo'
      expect(redis).to receive(:get).with('test-' + key).and_return 666
      redis_cache[key]
    end

    it 'can set a value for a key' do
      key, value = 'foo', { test: true }
      expect(redis).to receive(:set).with('test-' + key, JSON(value))
      redis_cache[key] = value
    end

    it 'can determine if key exists' do
      key = 'foo'
      expect(redis).to receive(:exists?).with('test-' + key).and_return(false, true)
      expect(redis_cache.key?('foo')).to eq false
      expect(redis_cache.key?('foo')).to eq true
    end

    it 'can delete' do
      key = 'foo'
      expect(redis).to receive(:del).with('test-' + key)
      redis_cache.delete(key)
    end

    it 'returns size' do
      allow(redis).to receive(:scan_each).with(match: 'test-*').
        and_yield('test-foo').
        and_yield('test-bar').
        and_yield('test-baz')
      expect(redis_cache.size).to eq 3
    end

    it 'can clear' do
      expect(redis).to receive(:scan_each).with(match: 'test-*').and_yield(
        'test-foo'
      )
      expect(redis).to receive(:del).with('test-foo')
      expect(redis_cache.clear).to eq redis_cache
    end

    it 'can iterate over keys under a prefix' do
      expect(redis).to receive(:scan_each).with(match: 'test-*')
      redis_cache.to_a
    end
  end
end

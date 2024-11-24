require 'spec_helper'

RSpec.describe Ollama::Documents::SQLiteCache do
  let :prefix do
    'test-'
  end

  let :test_value do
    {
      key:       'test',
      text:      'test text',
      norm:      0.5,
      source:    'for-test.txt',
      tags:      %w[ test ],
      embedding: [ 0.5 ] * 1_024,
    }
  end

  let :cache do
    described_class.new prefix:
  end

  it 'can be instantiated' do
    expect(cache).to be_a described_class
  end

  it 'defaults to :memory: mode' do
    expect(cache.filename).to eq ':memory:'
  end

  it 'can be switchted to file mode' do
    expect(SQLite3::Database).to receive(:new).with('foo.sqlite').
      and_return(double.as_null_object)
    cache = described_class.new prefix:, filename: 'foo.sqlite'
    expect(cache.filename).to eq 'foo.sqlite'
  end

  it 'can get/set a key' do
    key, value = 'foo', test_value
    queried_value = nil
    expect {
      cache[key] = value
    }.to change {
      queried_value = cache[key]
    }.from(nil).to(Ollama::Documents::Record[value])
    expect(queried_value.embedding).to eq [ 0.5 ] * 1_024
  end

  it 'can determine if key exists' do
    key, value = 'foo', test_value
    expect {
      cache[key] = value
    }.to change {
      cache.key?(key)
    }.from(false).to(true)
  end

  it 'can set key with different prefixes' do
    key, value = 'foo', test_value
    expect {
      cache[key] = value
    }.to change {
      cache.size
    }.from(0).to(1)
    cache2 = cache.dup
    cache2.prefix = 'test2-'
    expect {
      cache2[key] = value
    }.to change {
      cache2.size
    }.from(0).to(1)
    expect(cache.size).to eq 1
    s = 0
    cache.full_each { s += 1 }
    expect(s).to eq 2
  end

  it 'can delete' do
    key, value = 'foo', test_value
    expect(cache.delete(key)).to be_falsy
    cache[key] = value
    expect {
      expect(cache.delete(key)).to be_truthy
    }.to change {
      cache.key?(key)
    }.from(true).to(false)
  end

  it 'returns size' do
    key, value = 'foo', test_value
    expect {
      cache[key] = value
    }.to change {
      cache.size
    }.from(0).to(1)
  end

  it 'can convert_to_vector' do
    vector = [ 23.0, 666.0 ]
    expect(cache.convert_to_vector(vector)).to eq vector
  end

  it 'can clear' do
    key, value = 'foo', { embedding: [ 0.5 ] * 1_024 }
    cache[key] = value
    expect {
      expect(cache.clear).to eq cache
    }.to change {
      cache.size
    }.from(1).to(0)
  end

  it 'can clear for tags' do
    key, value = 'foo', { tags: %w[ foo ], embedding: [ 0.5 ] * 1_024 }
    cache[key] = value
    key, value = 'bar', { embedding: [ 0.5 ] * 1_024 }
    cache[key] = value
    expect {
      expect(cache.clear_for_tags(%w[ #foo ])).to eq cache
    }.to change {
      cache.size
    }.from(2).to(1)
    expect(cache).not_to be_key 'foo'
    expect(cache).to be_key 'bar'
  end

  it 'can return tags' do
    key, value = 'foo', { tags: %w[ foo ], embedding: [ 0.5 ] * 1_024 }
    cache[key] = value
    key, value = 'bar', { tags: %w[ bar baz ], embedding: [ 0.5 ] * 1_024 }
    cache[key] = value
    tags = cache.tags
    expect(tags).to be_a Ollama::Utils::Tags
    expect(tags.to_a).to eq %w[ bar baz foo ]
  end

  it 'can iterate over keys under a prefix' do
    cache['foo'] = test_value
    expect(cache.to_a).to eq [ [ 'test-foo', Ollama::Documents::Record[test_value] ] ]
  end
end

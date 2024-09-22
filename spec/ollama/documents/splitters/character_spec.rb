require 'spec_helper'

RSpec.describe Ollama::Documents::Splitters::Character do
  let :splitter do
    described_class.new chunk_size: 23, combining_string: ''
  end

  it 'can be instantiated' do
    expect(splitter).to be_a described_class
  end

  it 'can split' do
    text = [ ?A * 10 ] * 10 * "\n\n"
    result = splitter.split(text)
    expect(result.count).to eq 5
    expect(result.to_a.join('')).to eq ?A * 100
  end

  it 'can split combining with separation' do
    splitter = described_class.new chunk_size: 25, include_separator: false,
      combining_string: ?X
    text = [ ?A * 10 ] * 10 * "\n\n"
    result = splitter.split(text)
    expect(result.count).to eq 5
    expect(result.to_a.join(?B)).to eq\
      "AAAAAAAAAAXAAAAAAAAAAXBAAAAAAAAAAAAAAAAAAAAXBAAAAAAAAAAAAAAAAAAAAXB"\
      "AAAAAAAAAAAAAAAAAAAAXBAAAAAAAAAAAAAAAAAAAAX"
  end

  it 'can split including separator' do
    splitter = described_class.new chunk_size: 25, include_separator: true,
      combining_string: ''
    text = [ ?A * 10 ] * 10 * "\n\n"
    result = splitter.split(text)
    expect(result.count).to eq 5
    expect(result.to_a.join('')).to eq text
  end

  it 'cannot split' do
    text = [ ?A * 10 ] * 10 * "\n"
    result = splitter.split(text)
    expect(result.count).to eq 1
    expect(result.to_a.join('').count(?A)).to eq text.count(?A)
  end

  it 'cannot split2' do
    text = ?A * 25
    result = splitter.split(text)
    expect(result.count).to eq 1
    expect(result.to_a.join('')).to eq ?A * 25
  end

  it 'can split sentences' do
    text     = "foo.foo. bar!bar! baz?baz? quux.\nquux."
    splitter = described_class.new(separator: /[.!?]\s*(?:\b|\z)/, chunk_size: 2)
    result   = splitter.split(text)
    expect(result.to_a).to eq %w[ foo foo bar bar baz baz quux quux ]
  end
end

RSpec.describe Ollama::Documents::Splitters::RecursiveCharacter do
  let :splitter do
    described_class.new chunk_size: 23, combining_string: ''
  end

  it 'can be instantiated' do
    expect(splitter).to be_a described_class
  end

  it 'can split' do
    text = [ ?A * 10 ] * 10 * "\n\n"
    result = splitter.split(text)
    expect(result.count).to eq 5
    expect(result.to_a.join('')).to eq ?A * 100
  end

  it 'cannot split' do
    splitter = described_class.new chunk_size: 23, include_separator: true,
      separators: described_class::DEFAULT_SEPARATORS[0..-2]
    text = ?A * 25
    result = splitter.split(text)
    expect(result.count).to eq 1
    expect(result.to_a.join('')).to eq ?A * 25
  end

  it 'can split including separator' do
    splitter = described_class.new chunk_size: 25, include_separator: true,
      combining_string: ''
    text = [ ?A * 10 ] * 10 * "\n\n"
    result = splitter.split(text)
    expect(result.count).to eq 5
    expect(result.to_a.join('')).to eq text
  end

  it 'can split single newline as well' do
    text = [ ?A * 10 ] * 10 * "\n"
    result = splitter.split(text)
    expect(result.count).to eq 5
    expect(result.to_a.join('')).to eq ?A * 100
  end

  it 'can split single newline as well including separator' do
    splitter = described_class.new chunk_size: 25, include_separator: true,
      combining_string: ''
    text = [ ?A * 10 ] * 10 * "\n"
    result = splitter.split(text)
    expect(result.count).to eq 5
    expect(result.to_a.join('')).to eq text
  end
end

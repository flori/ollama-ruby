require 'spec_helper'

RSpec.describe Ollama::Documents::Splitters::Semantic do
  let :ollama do
    double('Ollama::Client')
  end

  let :splitter do
    described_class.new ollama:, model: 'mxbai-embed-large'
  end

  let :embeddings do
    JSON(File.read(asset('embeddings.json')))
  end

  it 'can be instantiated' do
    expect(splitter).to be_a described_class
  end

  before do
    allow(ollama).to receive(:embed).and_return(double(embeddings:))
  end

  it 'can split with breakpoint :percentile' do
    text = ([ "A" * 10 ] * 3 + [ "B" * 10 ] * 3 + [ "A" * 10 ] * 3) * ". "
    result = splitter.split(text, breakpoint: :percentile, percentile: 75)
    expect(result.count).to eq 3
    expect(result.to_a.join('').count(?A)).to eq text.count(?A)
    expect(result.to_a.join('').count(?B)).to eq text.count(?B)
  end

  it 'can split with breakpoint :percentile' do
    described_class.new ollama:, model: 'mxbai-embed-large', chunk_size: 50
    text = ([ "A" * 10 ] * 6 + [ "B" * 10 ] * 3 + [ "A" * 10 ] * 3) * ". "
    result = splitter.split(text, breakpoint: :percentile, percentile: 75)
    expect(result.count).to eq 4
    expect(result.to_a.join('').count(?A)).to eq text.count(?A)
    expect(result.to_a.join('').count(?B)).to eq text.count(?B)
  end

  it 'can split with breakpoint :standard_deviation' do
    text = ([ "A" * 10 ] * 3 + [ "B" * 10 ] * 3 + [ "A" * 10 ] * 3) * ". "
    result = splitter.split(text, breakpoint: :standard_deviation, percentage: 100)
    expect(result.count).to eq 3
    expect(result.to_a.join('').count(?A)).to eq text.count(?A)
    expect(result.to_a.join('').count(?B)).to eq text.count(?B)
  end

  it 'can split with breakpoint :interquartile' do
    text = ([ "A" * 10 ] * 3 + [ "B" * 10 ] * 3 + [ "A" * 10 ] * 3) * ". "
    result = splitter.split(text, breakpoint: :interquartile, percentage: 75)
    expect(result.count).to eq 3
    expect(result.to_a.join('').count(?A)).to eq text.count(?A)
    expect(result.to_a.join('').count(?B)).to eq text.count(?B)
  end
end

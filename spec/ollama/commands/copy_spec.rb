require 'spec_helper'

describe Ollama::Commands::Copy do
  it 'can be instantiated' do
    copy = described_class.new(source: 'llama3.1', destination: 'camell3')
    expect(copy).to be_a described_class
  end

  it 'can be converted to JSON' do
    copy = described_class.new(source: 'llama3.1', destination: 'camell3')
    expect(copy.as_json).to include(
      source: 'llama3.1', destination: 'camell3', stream: false
    )
    expect(copy.to_json).to eq(
      '{"source":"llama3.1","destination":"camell3","stream":false}'
    )
  end

  it 'can perform' do
    copy = described_class.new(source: 'llama3.1', destination: 'camell3')
    copy.client = ollama = double('Ollama::Client')
    expect(ollama).to receive(:request).with(
      method: :post, path: '/api/copy', handler: Ollama::Handlers::NOP, stream: false,
      body: '{"source":"llama3.1","destination":"camell3","stream":false}'
    )
    copy.perform(Ollama::Handlers::NOP)
  end
end

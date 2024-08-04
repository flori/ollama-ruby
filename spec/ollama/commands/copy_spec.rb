require 'spec_helper'

RSpec.describe Ollama::Commands::Copy do
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
      '{"json_class":"Ollama::Commands::Copy","source":"llama3.1","destination":"camell3","stream":false}'
    )
  end

  it 'can perform' do
    copy = described_class.new(source: 'llama3.1', destination: 'camell3')
    copy.client = client = double('client')
    expect(client).to receive(:request).with(
      method: :post, path: '/api/copy', handler: Ollama::Handlers::NOP, stream: false,
      body: '{"json_class":"Ollama::Commands::Copy","source":"llama3.1","destination":"camell3","stream":false}'
    )
    copy.perform(Ollama::Handlers::NOP)
  end
end

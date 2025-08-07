require 'spec_helper'

describe Ollama::Commands::Push do
  it 'can be instantiated' do
    push = described_class.new(model: 'llama3.1')
    expect(push).to be_a described_class
  end

  it 'can be converted to JSON' do
    push = described_class.new(model: 'llama3.1', stream: true)
    expect(push.as_json).to include(
      model: 'llama3.1', stream: true
    )
    expect(push.to_json).to eq(
      '{"model":"llama3.1","stream":true}'
    )
  end

  it 'can perform' do
    push = described_class.new(model: 'llama3.1', stream: true)
    push.client = ollama = double('Ollama::Client')
    expect(ollama).to receive(:request).with(
      method: :post, path: '/api/push', handler: Ollama::Handlers::NOP, stream: true,
      body: '{"model":"llama3.1","stream":true}'
    )
    push.perform(Ollama::Handlers::NOP)
  end
end

require 'spec_helper'

RSpec.describe Ollama::Commands::Push do
  it 'can be instantiated' do
    push = described_class.new(name: 'llama3.1')
    expect(push).to be_a described_class
  end

  it 'can be converted to JSON' do
    push = described_class.new(name: 'llama3.1', stream: true)
    expect(push.as_json).to include(
      name: 'llama3.1', stream: true
    )
    expect(push.to_json).to eq(
      '{"json_class":"Ollama::Commands::Push","name":"llama3.1","stream":true}'
    )
  end

  it 'can perform' do
    push = described_class.new(name: 'llama3.1', stream: true)
    push.client = ollama = double('Ollama::Client')
    expect(ollama).to receive(:request).with(
      method: :post, path: '/api/push', handler: Ollama::Handlers::NOP, stream: true,
      body: '{"json_class":"Ollama::Commands::Push","name":"llama3.1","stream":true}'
    )
    push.perform(Ollama::Handlers::NOP)
  end
end

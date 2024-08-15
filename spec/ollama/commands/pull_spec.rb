require 'spec_helper'

RSpec.describe Ollama::Commands::Pull do
  it 'can be instantiated' do
    pull = described_class.new(name: 'llama3.1')
    expect(pull).to be_a described_class
  end

  it 'can be converted to JSON' do
    pull = described_class.new(name: 'llama3.1', stream: true)
    expect(pull.as_json).to include(
      name: 'llama3.1', stream: true
    )
    expect(pull.to_json).to eq(
      '{"json_class":"Ollama::Commands::Pull","name":"llama3.1","stream":true}'
    )
  end

  it 'can perform' do
    pull = described_class.new(name: 'llama3.1', stream: true)
    pull.client = ollama = double('Ollama::Client')
    expect(ollama).to receive(:request).with(
      method: :post, path: '/api/pull', handler: Ollama::Handlers::NOP, stream: true,
      body: '{"json_class":"Ollama::Commands::Pull","name":"llama3.1","stream":true}'
    )
    pull.perform(Ollama::Handlers::NOP)
  end
end

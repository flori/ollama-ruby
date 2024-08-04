require 'spec_helper'

RSpec.describe Ollama::Commands::Delete do
  it 'can be instantiated' do
    delete = described_class.new(name: 'llama3.1')
    expect(delete).to be_a described_class
  end

  it 'can be converted to JSON' do
    delete = described_class.new(name: 'llama3.1')
    expect(delete.as_json).to include(
      name: 'llama3.1', stream: false
    )
    expect(delete.to_json).to eq(
      '{"json_class":"Ollama::Commands::Delete","name":"llama3.1","stream":false}'
    )
  end

  it 'can perform' do
    delete = described_class.new(name: 'llama3.1')
    delete.client = client = double('client')
    expect(client).to receive(:request).with(
      method: :delete, path: '/api/delete', handler: Ollama::Handlers::NOP, stream: false,
      body: '{"json_class":"Ollama::Commands::Delete","name":"llama3.1","stream":false}'
    )
    delete.perform(Ollama::Handlers::NOP)
  end
end

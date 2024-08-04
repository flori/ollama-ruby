require 'spec_helper'

RSpec.describe Ollama::Commands::Generate do
  it 'can be instantiated' do
    generate = described_class.new(model: 'llama3.1', prompt: 'Hello World')
    expect(generate).to be_a described_class
  end

  it 'can be converted to JSON' do
    generate = described_class.new(model: 'llama3.1', prompt: 'Hello World')
    expect(generate.as_json).to include(
      model: 'llama3.1', prompt: 'Hello World'
    )
    expect(generate.to_json).to eq(
      '{"json_class":"Ollama::Commands::Generate","model":"llama3.1","prompt":"Hello World"}'
    )
  end

  it 'can perform' do
    generate = described_class.new(model: 'llama3.1', prompt: 'Hello World', stream: true)
    generate.client = client = double('client')
    expect(client).to receive(:request).
      with(
        method: :post, path: '/api/generate', handler: Ollama::Handlers::NOP, stream: true,
        body: '{"json_class":"Ollama::Commands::Generate","model":"llama3.1","prompt":"Hello World","stream":true}'
      )
    generate.perform(Ollama::Handlers::NOP)
  end
end

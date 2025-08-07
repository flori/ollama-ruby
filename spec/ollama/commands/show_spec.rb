require 'spec_helper'

describe Ollama::Commands::Show do
  it 'can be instantiated' do
    show = described_class.new(model: 'llama3.1')
    expect(show).to be_a described_class
  end

  it 'can be converted to JSON' do
    show = described_class.new(model: 'llama3.1')
    expect(show.as_json).to include(
      model: 'llama3.1', stream: false
    )
    expect(show.to_json).to eq(
      '{"model":"llama3.1","stream":false}'
    )
  end

  it 'can perform' do
    show = described_class.new(model: 'llama3.1')
    show.client = ollama = double('Ollama::Client')
    expect(ollama).to receive(:request).with(
      method: :post, path: '/api/show', handler: Ollama::Handlers::NOP ,stream: false,
      body: '{"model":"llama3.1","stream":false}'
    )
    show.perform(Ollama::Handlers::NOP)
  end
end

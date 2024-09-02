require 'spec_helper'

RSpec.describe Ollama::Commands::Show do
  it 'can be instantiated' do
    show = described_class.new(name: 'llama3.1')
    expect(show).to be_a described_class
  end

  it 'can be converted to JSON' do
    show = described_class.new(name: 'llama3.1')
    expect(show.as_json).to include(
      name: 'llama3.1', stream: false
    )
    expect(show.to_json).to eq(
      '{"name":"llama3.1","stream":false}'
    )
  end

  it 'can perform' do
    show = described_class.new(name: 'llama3.1')
    show.client = ollama = double('Ollama::Client')
    expect(ollama).to receive(:request).with(
      method: :post, path: '/api/show', handler: Ollama::Handlers::NOP ,stream: false,
      body: '{"name":"llama3.1","stream":false}'
    )
    show.perform(Ollama::Handlers::NOP)
  end
end

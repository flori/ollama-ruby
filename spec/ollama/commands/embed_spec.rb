require 'spec_helper'

RSpec.describe Ollama::Commands::Embed do
  it 'can be instantiated' do
    embed = described_class.new(
      model: 'all-minilm',
      input: 'Why is the sky blue?',
    )
    expect(embed).to be_a described_class
  end

  it 'can be converted to JSON' do
    embed = described_class.new(
      model: 'all-minilm',
      input: 'Why is the sky blue?'
    )
    expect(embed.as_json).to include(
      model: 'all-minilm', input: 'Why is the sky blue?',
    )
    expect(embed.to_json).to eq(
      '{"json_class":"Ollama::Commands::Embed","model":"all-minilm","input":"Why is the sky blue?","stream":false}'
    )
  end

  it 'can be converted to JSON with array input' do
    embed = described_class.new(
      model: 'all-minilm',
      input: [ 'Why is the sky blue?', 'Why is the grass green?' ],
    )
    expect(embed.as_json).to include(
      model: 'all-minilm', input: [ 'Why is the sky blue?', 'Why is the grass green?' ],
    )
    expect(embed.to_json).to eq(
      '{"json_class":"Ollama::Commands::Embed","model":"all-minilm","input":["Why is the sky blue?","Why is the grass green?"],"stream":false}'
    )
  end


  it 'can perform' do
    embed = described_class.new(
      model: 'all-minilm',
      input: 'Why is the sky blue?'
    )
    embed.client = client = double('client')
    expect(client).to receive(:request).
      with(
        method: :post, path: '/api/embed', handler: Ollama::Handlers::NOP, stream: false,
        body: '{"json_class":"Ollama::Commands::Embed","model":"all-minilm","input":"Why is the sky blue?","stream":false}'
      )
    embed.perform(Ollama::Handlers::NOP)
  end
end

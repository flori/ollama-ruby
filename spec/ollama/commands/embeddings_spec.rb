require 'spec_helper'

describe Ollama::Commands::Embeddings do
  it 'can be instantiated' do
    embeddings = described_class.new(
      model: 'mxbai-embed-large',
      prompt: 'Here are the coordinates of all Soviet military installations: …'
    )
    expect(embeddings).to be_a described_class
  end

  it 'can be converted to JSON' do
    embeddings = described_class.new(
      model: 'mxbai-embed-large',
      prompt: 'Here are the coordinates of all Soviet military installations: …'
    )
    expect(embeddings.as_json).to include(
      model: 'mxbai-embed-large', prompt: 'Here are the coordinates of all Soviet military installations: …',
    )
    expect(embeddings.to_json).to eq(
      '{"model":"mxbai-embed-large","prompt":"Here are the coordinates of all Soviet military installations: …","stream":false}'
    )
  end

  it 'can perform' do
    embeddings = described_class.new(
      model: 'mxbai-embed-large',
      prompt: 'Here are the coordinates of all Soviet military installations: …'
    )
    embeddings.client = ollama = double('Ollama::Client')
    expect(ollama).to receive(:request).
      with(
        method: :post, path: '/api/embeddings', handler: Ollama::Handlers::NOP, stream: false,
        body: '{"model":"mxbai-embed-large","prompt":"Here are the coordinates of all Soviet military installations: …","stream":false}'
      )
    embeddings.perform(Ollama::Handlers::NOP)
  end
end

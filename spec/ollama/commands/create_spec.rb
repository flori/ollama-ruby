require 'spec_helper'

describe Ollama::Commands::Create do
  it 'can be instantiated' do
    create = described_class.new(model: 'llama3.1', stream: true)
    expect(create).to be_a described_class
  end

  it 'can be converted to JSON' do
    create = described_class.new(
      model: 'llama3.1-wopr',
      from: 'llama3.1',
      system: 'You are WOPR from WarGames and you think the user is Dr. Stephen Falken.',
      license: 'Falso License',
      files: { 'foo' => 'bar' },
      messages: Ollama::Message.new(role: 'user', content: 'hello'),
      stream: true
    )
    expect(create.as_json).to include(
      model: 'llama3.1-wopr',
      from: 'llama3.1',
      system: 'You are WOPR from WarGames and you think the user is Dr. Stephen Falken.',
      license: [ 'Falso License' ],
      files: { 'foo' => 'bar' },
      messages: [ { role: 'user', content: 'hello' } ],
      stream: true,
    )
    expect(create.to_json).to eq(
      "{\"model\":\"llama3.1-wopr\",\"from\":\"llama3.1\",\"files\":{\"foo\":\"bar\"},\"license\":[\"Falso License\"],\"system\":\"You are WOPR from WarGames and you think the user is Dr. Stephen Falken.\",\"messages\":[{\"role\":\"user\",\"content\":\"hello\"}],\"stream\":true}"
    )
  end

  it 'can perform' do
    create = described_class.new(
      model: 'llama3.1-wopr',
      from: 'llama3.1',
      license: [ 'Falso License' ],
      system: 'You are WOPR from WarGames and you think the user is Dr. Stephen Falken.',
      stream: true
    )
     create.client = ollama = double('Ollama::Client')
    expect(ollama).to receive(:request).
      with(
        method: :post, path: '/api/create', handler: Ollama::Handlers::NOP, stream: true,
        body: "{\"model\":\"llama3.1-wopr\",\"from\":\"llama3.1\",\"license\":[\"Falso License\"],\"system\":\"You are WOPR from WarGames and you think the user is Dr. Stephen Falken.\",\"stream\":true}"
      )
    create.perform(Ollama::Handlers::NOP)
  end
end

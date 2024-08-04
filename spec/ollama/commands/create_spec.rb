require 'spec_helper'

RSpec.describe Ollama::Commands::Create do
  it 'can be instantiated' do
    create = described_class.new(name: 'llama3.1', stream: true)
    expect(create).to be_a described_class
  end

  it 'can be converted to JSON' do
    create = described_class.new(
      name: 'llama3.1-wopr',
      modelfile: "FROM llama3.1\nSYSTEM You are WOPR from WarGames and you think the user is Dr. Stephen Falken.",
      stream: true
    )
    expect(create.as_json).to include(
      name: 'llama3.1-wopr', modelfile: "FROM llama3.1\nSYSTEM You are WOPR from WarGames and you think the user is Dr. Stephen Falken.", stream: true,
    )
    expect(create.to_json).to eq(
      '{"json_class":"Ollama::Commands::Create","name":"llama3.1-wopr","modelfile":"FROM llama3.1\nSYSTEM You are WOPR from WarGames and you think the user is Dr. Stephen Falken.","stream":true}'
    )
  end

  it 'can perform' do
    create = described_class.new(
      name: 'llama3.1-wopr',
      modelfile: "FROM llama3.1\nSYSTEM You are WOPR from WarGames and you think the user is Dr. Stephen Falken.",
      stream: true
    )
    create.client = client = double('client')
    expect(client).to receive(:request).
      with(
        method: :post, path: '/api/create', handler: Ollama::Handlers::NOP, stream: true,
        body: '{"json_class":"Ollama::Commands::Create","name":"llama3.1-wopr","modelfile":"FROM llama3.1\nSYSTEM You are WOPR from WarGames and you think the user is Dr. Stephen Falken.","stream":true}'
      )
    create.perform(Ollama::Handlers::NOP)
  end
end

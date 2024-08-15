require 'spec_helper'

RSpec.describe Ollama::Commands::Chat do
  it 'can be instantiated' do
    messages = [
      Ollama::Message.new(role: 'user', content: "Let's play Global Thermonuclear War.")
    ]
    chat = described_class.new(model: 'llama3.1', messages:, stream: true)
    expect(chat).to be_a described_class
  end

  it 'can handle hashes as messages' do
    messages = { role: 'user', content: "Let's play Global Thermonuclear War." }
    chat = described_class.new(model: 'llama3.1', messages:, stream: true)
    expect(chat).to be_a described_class
  end

  it 'can handle arrays of hashes as messages' do
    messages = [
      { role: 'user', content: "Let's play Global Thermonuclear War." }
    ]
    chat = described_class.new(model: 'llama3.1', messages:, stream: true)
    expect(chat).to be_a described_class
  end

  it 'can be converted to JSON' do
    messages = [
      Ollama::Message.new(role: 'user', content: "Let's play Global Thermonuclear War.")
    ]
    chat = described_class.new(model: 'llama3.1', messages:, stream: true)
    expect(chat.as_json).to include(
      model: 'llama3.1', messages: messages.map(&:as_json), stream: true,
    )
    expect(chat.to_json).to eq(
      '{"json_class":"Ollama::Commands::Chat","model":"llama3.1","messages":[{"json_class":"Ollama::Message","role":"user","content":"Let\'s play Global Thermonuclear War."}],"stream":true}'
    )
  end

  it 'can perform' do
    messages = [
      Ollama::Message.new(role: 'user', content: "Let's play Global Thermonuclear War.")
    ]
    chat = described_class.new(model: 'llama3.1', messages:, stream: true)
    chat.client = ollama = double('Ollama::Client')
    expect(ollama).to receive(:request).
      with(
        method: :post, path: '/api/chat', handler: Ollama::Handlers::NOP, stream: true,
        body: '{"json_class":"Ollama::Commands::Chat","model":"llama3.1","messages":[{"json_class":"Ollama::Message","role":"user","content":"Let\'s play Global Thermonuclear War."}],"stream":true}'
      )
    chat.perform(Ollama::Handlers::NOP)
  end
end

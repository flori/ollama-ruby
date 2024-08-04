require 'spec_helper'

RSpec.describe Ollama::Message do
  let :image do
    Ollama::Image.for_string("test")
  end

  let :message do
    described_class.new(
      role: 'user',
      content: 'hello world',
      images: image
    )
  end

  it 'can be instantiated' do
    expect(message).to be_a described_class
  end

  it 'can be converted to JSON' do
    expect(message.as_json).to eq(
      json_class: described_class.name,
      role: 'user',
      content: 'hello world',
      images: [ image ],
    )
    expect(message.to_json).to eq(
      '{"json_class":"Ollama::Message","role":"user","content":"hello world","images":["dGVzdA==\n"]}'
    )
  end

  it 'can be restored from JSON' do
    expect(JSON(<<~'end', create_additions: true)).to be_a described_class
      {"json_class":"Ollama::Message","role":"user","content":"hello world","images":["dGVzdA==\n"]}
    end
  end
end

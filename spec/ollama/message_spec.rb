require 'spec_helper'

RSpec.describe Ollama::Message do
  let :image do
    Ollama::Image.for_string("test")
  end

  let :message do
    described_class.new(
      role:    'user',
      content: 'hello world',
      thinking: 'which world?',
      images:  image
    )
  end

  it 'can be instantiated' do
    expect(message).to be_a described_class
  end

  it 'can be converted to JSON' do
    expect(message.as_json).to eq(
      role: 'user',
      content: 'hello world',
      thinking: 'which world?',
      images: [ image ],
    )
    expect(message.to_json).to eq(
      '{"role":"user","content":"hello world","thinking":"which world?","images":["dGVzdA==\n"]}'
    )
  end

  it 'can be restored from JSON' do
    expect(described_class.from_hash(JSON(<<~'end'))).to be_a described_class
      {"role":"user","content":"hello world","thinking":"which world?","images":["dGVzdA==\n"]}
    end
  end

  it 'can be eq(ual) to itself' do
    expect(message).to eq message
  end

  it 'can be eq(ual) to other message' do
    expect(message).to eq message.dup
    expect(message).not_to equal message.dup
  end
end

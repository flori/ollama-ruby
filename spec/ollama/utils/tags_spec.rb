require 'spec_helper'

RSpec.describe Ollama::Utils::Tags do
  it 'can be instantiated' do
    expect(described_class.new).to be_a described_class
  end

  it 'can contain unique tags and is sorted' do
    tags = described_class.new(%w[ bar foo ])
    expect(tags.to_a).to eq %w[ bar foo ]
  end

  it 'tags can be added to it' do
    tags = described_class.new([ 'foo' ])
    tags.add 'bar'
    expect(tags.to_a).to eq %w[ bar foo ]
    tags.merge %w[ baz baz2 ]
    expect(tags.to_a).to eq %w[ bar baz baz2 foo ]
  end

  it 'can be output nicely' do
    expect(described_class.new(%w[ foo bar ]).to_s).to eq '#bar #foo'
  end
end

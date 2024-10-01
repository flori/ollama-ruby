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
  end

  it 'can increase in size' do
    tags = described_class.new
    expect { tags.add 'foo' }.to change { tags.size }.from(0).to(1)
    expect { tags.add 'bar' }.to change { tags.size }.from(1).to(2)
  end

  it 'can be cleared' do
    tags = described_class.new([ 'foo', 'bar' ])
    expect { tags.clear }.to change { tags.size }.from(2).to(0)
  end

  it 'tags can be empt' do
    tags = described_class.new([ 'foo' ])
    expect { tags.clear }.to change { tags.empty? }.from(false).to(true)
  end

  it 'can be output nicely' do
    expect(described_class.new(%w[ foo bar ]).to_s).to eq '#bar #foo'
  end

  it 'can be output nicely with links to source' do
    tags = described_class.new([ 'foo' ], source: 'https://foo.example.com')
    tags.add 'bar', source: '/path/to/bar.html'
    expect(tags.to_a).to eq %w[ bar foo ]
    tags.all? { expect(_1).to be_a(Ollama::Utils::Tags::Tag) }
    expect(tags.to_s).to eq(
      "\e]8;;file:///path/to/bar.html\e\\#bar\e]8;;\e\\ \e]8;;https://foo.example.com\e\\#foo\e]8;;\e\\"
    )
  end
end

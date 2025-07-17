require 'spec_helper'

RSpec.describe Ollama::Options do
  let :options do
    described_class.new(
      penalize_newline: true,
      num_ctx: 8192,
      temperature: 0.7,
    )
  end

  it 'can be instantiated' do
    expect(options).to be_a described_class
  end

  it 'can be configured by loading from JSON' do
    options = described_class.load_from_json(asset('options.json'))
    expect(options).to be_a described_class
    expect(options.num_ctx).to eq(16384)
    expect(options.seed).to eq(-1)
    expect(options.num_predict).to eq(1024)
    expect(options.temperature).to be_within(1E-6).of(0.666)
    expect(options.top_p).to be_within(0.001).of(0.95)
    expect(options.min_p).to be_within(0.001).of(0.1)
  end

  it 'can be empty' do
    expect(described_class.new).to be_empty
  end

  it 'can be used to cast hashes' do
    expect(described_class[{
      penalize_newline: true,
      num_ctx: 8192,
      temperature: 0.7,
    }]).to be_a described_class
  end

  it 'raises errors when casting goes all wrong' do
    expect {
      described_class[{
        penalize_newline: :tertium,
        num_ctx: 8192,
        temperature: 0.7,
      }]
    }.to raise_error(TypeError)
  end

  it 'throws error for invalid types' do
    expect { described_class.new(temperature: Class.new) }.
      to raise_error(TypeError)
  end

  it 'throws error for invalid boolean values' do
    expect { described_class.new(penalize_newline: :tertium) }.
      to raise_error(TypeError)
  end
end

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

  it 'can used to cast hashes' do
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

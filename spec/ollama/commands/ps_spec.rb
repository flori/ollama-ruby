require 'spec_helper'

describe Ollama::Commands::Ps do
  let :ps do
    described_class.new
  end

  it 'can be instantiated' do
    expect(ps).to be_a described_class
  end

  it 'cannot be converted to JSON' do
    expect(ps).not_to respond_to(:as_json)
  end

  it 'can perform' do
    ps.client = ollama = double('Ollama::Client')
    expect(ollama).to receive(:request).
      with(
        method: :get, path: '/api/ps', handler: Ollama::Handlers::NOP,
        stream: false
      )
    ps.perform(Ollama::Handlers::NOP)
  end
end

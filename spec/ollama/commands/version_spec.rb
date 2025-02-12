require 'spec_helper'

RSpec.describe Ollama::Commands::Version do
  let :version do
    described_class.new
  end

  it 'can be instantiated' do
    expect(version).to be_a described_class
  end

  it 'cannot be converted to JSON' do
    expect(version).not_to respond_to(:as_json)
  end

  it 'can perform' do
    version.client = ollama = double('Ollama::Client')
    expect(ollama).to receive(:request).
      with(
        method: :get, path: '/api/version', handler: Ollama::Handlers::NOP,
        stream: false
      )
    version.perform(Ollama::Handlers::NOP)
  end
end

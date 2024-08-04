require 'spec_helper'

RSpec.describe Ollama::Commands::Tags do
  let :tags do
    described_class.new
  end

  it 'can be instantiated' do
    expect(tags).to be_a described_class
  end

  it 'cannot be converted to JSON' do
    expect(tags).not_to respond_to(:as_json)
  end

  it 'can perform' do
    tags.client = client = double('client')
    expect(client).to receive(:request).
      with(method: :get, path: '/api/tags', stream: false, handler: Ollama::Handlers::NOP)
    tags.perform(Ollama::Handlers::NOP)
  end
end

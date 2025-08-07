require 'spec_helper'

describe Ollama::Handlers::Single do
  it 'has .call' do
    expect_any_instance_of(described_class).to receive(:call).with(:foo)
    described_class.call(:foo)
  end

  it 'can collect responses in an array' do
    single = described_class.new(output:)
    response1 = Ollama::Response[foo: 'testing1']
    response2 = Ollama::Response[foo: 'testing2']
    single.call(response1)
    single.call(response2)
    expect(single.result).to eq [ response1, response2 ]
  end

  it 'can return only the single result' do
    single = described_class.new(output:)
    response = Ollama::Response[foo: 'testing']
    single.call(response)
    expect(single.result).to eq response
  end
end

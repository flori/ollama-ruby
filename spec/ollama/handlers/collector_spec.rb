require 'spec_helper'

RSpec.describe Ollama::Handlers::Collector do
  it 'has .call' do
    expect_any_instance_of(described_class).to receive(:call).with(:foo)
    described_class.call(:foo)
  end

  it 'can collect responses in an array' do
    collector = described_class.new(output:)
    response = Ollama::Response[foo: 'testing']
    collector.call(response)
    expect(collector.result).to eq [ response ]
  end
end

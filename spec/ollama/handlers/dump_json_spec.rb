require 'spec_helper'

RSpec.describe Ollama::Handlers::DumpJSON do
  it 'has .call' do
    expect_any_instance_of(described_class).to receive(:call).with(:foo)
    described_class.call(:foo)
  end

  it 'can print pretty JSON' do
    output = double('output')
    expect(output).to receive(:puts).with(%Q'{\n  "foo": "testing"\n}')
    print = described_class.new(output:)
    response = Ollama::Response[foo: 'testing']
    print.call(response)
  end
end

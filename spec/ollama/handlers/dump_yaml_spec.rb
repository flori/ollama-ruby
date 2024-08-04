require 'spec_helper'

RSpec.describe Ollama::Handlers::DumpYAML do
  it 'has .call' do
    expect_any_instance_of(described_class).to receive(:call).with(:foo)
    described_class.call(:foo)
  end

  it 'can print YAML' do
    output = double('output')
    expect(output).to receive(:puts).with(
      "--- !ruby/object:Ollama::Response\nfoo: testing\n"
    )
    print = described_class.new(output:)
    response = Ollama::Response[foo: 'testing']
    print.call(response)
  end
end

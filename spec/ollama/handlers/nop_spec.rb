require 'spec_helper'

RSpec.describe Ollama::Handlers::NOP do
  it 'has .to_proc' do
    expect_any_instance_of(described_class).to receive(:call).with(:foo)
    described_class.call(:foo)
  end

  it 'can do nothing at all' do
    nop = described_class.new(output:)
    response = Ollama::Response[foo: 'testing']
    nop.call(response)
    expect(nop.result).to be_nil
  end
end

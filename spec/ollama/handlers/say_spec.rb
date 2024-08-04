require 'spec_helper'

RSpec.describe Ollama::Handlers::Say do
  it 'has .to_proc' do
    expect_any_instance_of(described_class).to receive(:call).with(:foo)
    described_class.call(:foo)
  end

  it 'can print response' do
    output = double('output', :sync= => true)
    expect(output).to receive(:print).with('testing')
    expect(output).to receive(:close)
    print = described_class.new(output:)
    response = double('response', response: 'testing', done: false)
    print.call(response)
    response = double('response', response: nil, message: nil, done: true)
    print.call(response)
  end

  it 'can print message content' do
    output = double('output', :sync= => true)
    expect(output).to receive(:print).with('testing')
    expect(output).to receive(:close)
    print = described_class.new(output:)
    response = double('response', response: nil, message: double(content: 'testing'), done: false)
    print.call(response)
    response = double('response', response: nil, message: nil, done: true)
    print.call(response)
  end
end

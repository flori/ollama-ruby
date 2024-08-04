require 'spec_helper'

RSpec.describe Ollama::Handlers::Progress do
  it 'has .to_proc' do
    expect_any_instance_of(described_class).to receive(:call).with(:foo)
    described_class.call(:foo)
  end

  it 'can display progress' do
    response = double('response', status: 'testing', completed: 23, total: 666)
    expect(infobar.counter).to receive(:progress).with(by: 23).and_call_original
    expect(infobar.display).to receive(:update).and_call_original
    described_class.new.call(response)
  end

  it 'can display errors in progress' do
    response = double('response', error: 'foo', status: nil, completed: nil, total: nil)
    progress = described_class.new
    expect(progress.output).to receive(:puts).with(/Error: .*foo/)
    progress.call(response)
  end
end

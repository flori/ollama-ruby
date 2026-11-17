describe Ollama::Handlers::Progress do
  it 'has .to_proc' do
    expect_any_instance_of(described_class).to receive(:call).with(:foo)
    described_class.call(:foo)
  end

  it 'can display progress' do
    response = double('response', status: 'testing', completed: 23, total: 666, error: nil)
    expect(infobar.counter).to receive(:progress).with(by: 23).and_call_original
    expect(infobar.display).to receive(:update).and_call_original
    described_class.new.call(response)
  end

  it 'can display errors in progress' do
    response = double('response', error: 'foo', status: nil, completed: nil, total: nil)
    progress = described_class.new
    expect(infobar).to receive(:puts).with(/Error: .*foo/)
    progress.call(response)
  end

  it 'finishes with progress message on success' do
    handler = described_class.new
    handler.call(double(status: 'downloading', completed: 10, total: 100, error: nil))
    expect(infobar).to receive(:finish).with(message: /10.00 B\/100.00 B/)
    expect(infobar).to receive(:newline)
    handler.call(double(status: 'success', completed: nil, total: nil, error: nil))
  end

  it 'finishes with checkmark on success without prior progress' do
    handler = described_class.new
    expect(infobar).to receive(:finish).with(message: '%l ✓')
    expect(infobar).to receive(:newline)
    handler.call(double(status: 'success', completed: nil, total: nil, error: nil))
  end
end

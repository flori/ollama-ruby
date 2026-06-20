describe Ollama::Commands::PushBlob do
  let :body do
    'test blob content'
  end

  let :push_blob do
    described_class.new(body: body)
  end

  it 'can be instantiated with a string' do
    expect(push_blob).to be_a described_class
  end

  it 'can be instantiated with an IO object' do
    io           = StringIO.new(body)
    push_blob_io = described_class.new(body: io)
    expect(push_blob_io).to be_a described_class
  end

  it 'cannot be converted to JSON' do
    expect(push_blob).not_to respond_to(:as_json)
  end

  it 'calculates the correct digest and path' do
    expected_digest = 'sha256:dccfe42873d40807d0da4be11f3a412e4914f1315288d3c6e8cf0a19a8928feb'
    expect(push_blob.digest).to eq expected_digest
    expect(push_blob.path).to eq "/api/blobs/#{expected_digest}"
  end

  it 'can perform' do
    handler = double('Ollama::Handlers::NOP').as_null_object
    push_blob.client = ollama = double('Ollama::Client')

    expect(handler).to receive(:result=).with(push_blob.digest)
    expect(ollama).to receive(:blob_exists?).and_return false
    expect(ollama).to receive(:upload_file).with(
      path: push_blob.path, body: push_blob.body, handler: handler
    )

    push_blob.perform(handler)
  end
end

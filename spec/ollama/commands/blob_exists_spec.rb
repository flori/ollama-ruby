describe Ollama::Commands::BlobExists do
  let :hex_digest do
    '5ee4f07cdb9beadbbb293e85803c569b01bd37ed059d2715faa7bb405f31caa6'
  end

  let :digest do
    "sha256:#{hex_digest}"
  end

  let :blob_exists do
    described_class.new(digest:)
  end

  it 'can be instantiated with a full digest' do
    expect(blob_exists).to be_a described_class
    expect(blob_exists.digest).to eq digest
  end

  it 'automatically prefixes 64-char hex digests' do
    be = described_class.new(digest: hex_digest)
    expect(be.digest).to eq "sha256:#{hex_digest}"
  end

  it 'computes digest when provided with a blob' do
    blob = StringIO.new('hello world')
    be = described_class.new(blob: blob)
    expect(be.digest).to start_with('sha256:')
    expect(be.digest).not_to be_nil
  end

  it 'raises ArgumentError if neither digest nor blob is provided' do
    expect { described_class.new }.to\
      raise_error(ArgumentError, 'require digest or blob to perform')
  end

  it 'cannot be converted to JSON' do
    expect(blob_exists).not_to respond_to(:as_json)
  end

  it 'can perform' do
    blob_exists.client = ollama = double('Ollama::Client')
    expect(ollama).to receive(:request).
      with(
        method: :head, path: "/api/blobs/#{digest}", handler: Ollama::Handlers::NOP,
        stream: false
      )
    blob_exists.perform(Ollama::Handlers::NOP)
  end
end

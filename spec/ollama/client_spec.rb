describe Ollama::Client do
  let :base_url do
    'https://ai.foo.bar'
  end

  let :ollama do
    described_class.new base_url:
  end

  it 'can be instantiated' do
    expect(ollama).to be_a described_class
  end

  it 'can be instantiated with config' do
    config = Ollama::Client::Config[base_url: base_url]
    client = described_class.configure_with(config)
    expect(client).to be_a described_class
    expect(client.base_url.to_s).to eq base_url
    expect(client.output).to be $stdout
  end

  it 'can be instantiated with config and api_key' do
    config = Ollama::Client::Config[base_url: base_url, api_key: 'the-secret']
    client = described_class.configure_with(config).expose
    expect(client).to be_a described_class
    expect(client.base_url.to_s).to eq base_url
    expect(client.api_key).to eq 'the-secret'
    expect(client.headers).to include(
      'Authorization' => 'Bearer the-secret'
    )
  end

  it 'can be instantiated with config loaded from JSON' do
    config = Ollama::Client::Config.load_from_json(asset('client.json'))
    config.base_url = base_url
    expect(config.read_timeout).to eq 3_600
    expect(config.connect_timeout).to eq 60
    client = described_class.configure_with(config)
    expect(client).to be_a described_class
    expect(client.base_url.to_s).to eq base_url
    expect(client.output).to be $stdout
    expect(client.instance_variable_get(:@connect_timeout)).to eq 60
    expect(client.instance_variable_get(:@read_timeout)).to eq 3_600
  end

  it 'can be configured via environment variable', protect_env: true do
    ENV.delete('OLLAMA_URL')
    expect { described_class.new }.to raise_error(ArgumentError)
    ENV['OLLAMA_URL'] = base_url
    expect(described_class.new).to be_a described_class
  end

  it 'can disable ssl peer verification' do
    expect(ollama).to be_ssl_verify_peer
    client2 = described_class.new(
      base_url: 'https://ai.foo.bar?ssl_verify_peer=false'
    )
    expect(client2).not_to be_ssl_verify_peer
  end

  it 'has a string representation' do
    expect(ollama.to_s).to eq '#<Ollama::Client@https://ai.foo.bar>'
  end

  let :excon do
    double('excon')
  end

  before do
    allow(Excon).to receive(:new).and_return(excon)
  end

  it 'can raise error based on status code 500' do
    expect(excon).to receive(:send).and_return(double(status: 500, body: '{}'))
    expect {
      ollama.generate(model: 'llama3.1', prompt: 'Hello World')
    }.to raise_error(Ollama::Errors::Error)
  end

  it 'can raise error based on status code 400' do
    expect(excon).to receive(:send).and_return(double(status: 400, body: '{}'))
    expect {
      ollama.generate(model: 'llama3.1', prompt: 'Hello World', think: true)
    }.to raise_error(Ollama::Errors::BadRequestError)
  end

  it 'can raise error based on status code 404' do
    expect(excon).to receive(:send).and_return(double(status: 404, body: '{}'))
    expect {
      ollama.generate(model: 'llama3.1', prompt: 'Hello World')
    }.to raise_error(Ollama::Errors::NotFoundError)
  end

  it 'can raise error on connection error' do
    expect(excon).to receive(:post).and_raise Excon::Error::Socket
    expect {
      ollama.generate(model: 'llama3.1', prompt: 'Hello World')
    }.to raise_error(Ollama::Errors::SocketError)
  end

  it 'can raise error on timeout' do
    expect(excon).to receive(:post).and_raise Excon::Errors::Timeout
    expect {
      ollama.generate(model: 'llama3.1', prompt: 'Hello World')
    }.to raise_error(Ollama::Errors::TimeoutError)
  end

  it 'can raise a generic error' do
    expect(excon).to receive(:post).and_raise Excon::Errors::Error
    expect {
      ollama.generate(model: 'llama3.1', prompt: 'Hello World')
    }.to raise_error(Ollama::Errors::Error)
  end

  describe 'handlers' do
    let :body do
      %{{"models":[{"name":"llama3.1:latest","model":"llama3.1:latest","size":6654289920,"digest":"62757c860e01d552d4e46b09c6b8d5396ef9015210105427e05a8b27d7727ed2","details":{"parent_model":"","format":"gguf","family":"llama","families":["llama"],"parameter_size":"8.0B","quantization_level":"Q4_0"},"expires_at":"2024-08-05T10:56:26.588713988Z","size_vram":6654289920}]}}
    end

    let :expected_response do
      JSON.parse(body, object_class: Ollama::Response)
    end

    before do
      allow(excon).to receive(:send).with(
        :get,
        body: nil,
        headers: hash_including(
          'Content-Type' => 'application/json; charset=utf-8',
        )
      ).and_return(double(status: 200, body:))
    end

    it 'can use procs directly' do
      response = nil
      ollama.ps { |r| response = r }
      expect(response).to eq expected_response
    end

    it 'can convert from handler instance to proc' do
      handler = Ollama::Handlers::NOP.new
      expect(handler).to receive(:call).with(expected_response)
      ollama.ps(&handler)
    end

    it 'can convert from handler class to proc' do
      handler = Ollama::Handlers::NOP
      expect_any_instance_of(handler).to receive(:call).with(expected_response)
      ollama.ps(&handler)
    end
  end

  describe 'performing' do
    it 'can generate without stream' do
      expect(excon).to receive(:send).with(
        :post,
        body:  '{"model":"llama3.1","prompt":"Hello World"}',
        headers: hash_including(
          'Content-Type' => 'application/json; charset=utf-8',
        )
      ).and_return(double(status: 200, body: '{}'))
      ollama.generate(model: 'llama3.1', prompt: 'Hello World')
    end

    it 'can soldier on with parse errors and output warning' do
      expect(excon).to receive(:send).with(
        :post,
        body:  '{"model":"llama3.1","prompt":"Hello World"}',
        headers: hash_including(
          'Content-Type' => 'application/json; charset=utf-8',
        )
      ).and_return(double(status: 200, body: '{i am so broken}'))
      expect(ollama).to receive(:warn).with(
        "Caught JSON::ParserError: expected object key, got 'i' at line 1 column 2"
      )
      expect(ollama.generate(model: 'llama3.1', prompt: 'Hello World')).to be nil
    end

    it 'can generate with stream' do
      expect(excon).to receive(:send).with(
        :post,
        body:  '{"model":"llama3.1","prompt":"Hello World","stream":true}',
        headers: hash_including(
          'Content-Type' => 'application/json; charset=utf-8',
        ),
        response_block: an_instance_of(Proc)
      ).and_return(double(status: 200, body: '{}'))
      ollama.generate(model: 'llama3.1', prompt: 'Hello World', stream: true)
    end
  end

  it 'can help' do
    expect($stdout).to receive(:puts).with(/Commands:.*?chat/)
    ollama.help
  end

  context 'blobs' do
    it 'can verify that a blob exists' do
      expect(excon).to receive(:head).
        and_return(double('Response', status: 200, body: ''))
      exists = ollama.blob_exists?(
        'sha256:5ee4f07cdb9beadbbb293e85803c569b01bd37ed059d2715faa7bb405f31caa6'
      )
      expect(exists).to eq true
    end

    it 'can falsify that a blob exists' do
      expect(excon).to receive(:head).and_raise Ollama::Errors::NotFoundError
      exists = ollama.blob_exists?(
        'sha256:5ee4f07cdb9beadbbb293e85803c569b01bd37ed059d2715faa7bb405f31ca6a'
      )
      expect(exists).to eq false
    end

    it 'can upload a file and return self on success' do
      body = StringIO.new('dummy content')
      handler = double('Handler', call: nil)

      expect(excon).to receive(:post).with(
        headers: hash_including('Content-Type' => 'application/octet-stream'),
        request_block: an_instance_of(Proc)
      ).and_return(double(status: 201, body: ''))

      expect(ollama.upload_file(path: '/api/blobs/abc', body: body, handler: handler)).to eq ollama
    end

    it 'can report progress via the handler' do
      content = 'Hello Ruby!'
      body = StringIO.new(content)
      handler = double('Handler')

      # We capture the block to simulate Excon calling it
      captured_block = nil
      expect(excon).to receive(:post) do |args|
        captured_block = args[:request_block]
        double(status: 201, body: '')
      end

      ollama.upload_file(path: '/api/blobs/abc', body: body, handler: handler)

      # Execute the block and verify the fake response is passed to the handler
      expect(handler).to receive(:call).with(an_instance_of(Ollama::Response))
      captured_block.call
    end

    it 'can raise error on non-success status' do
      body = StringIO.new('dummy content')
      handler = double('Handler', call: nil)

      expect(excon).to receive(:post).and_return(double(status: 400, body: 'Bad Request'))

      expect {
        ollama.upload_file(path: '/api/blobs/abc', body: body, handler: handler)
      }.to raise_error(Ollama::Errors::Error, /400 "Bad Request"/)
    end

    it 'can map Excon socket errors to Ollama::Errors::SocketError' do
      body = StringIO.new('dummy content')
      handler = double('Handler', call: nil)

      expect(excon).to receive(:post).and_raise(Excon::Errors::SocketError)

      expect {
        ollama.upload_file(path: '/api/blobs/abc', body: body, handler: handler)
      }.to raise_error(Ollama::Errors::SocketError)
    end

    it 'can map Excon timeout errors to Ollama::Errors::TimeoutError' do
      body = StringIO.new('dummy content')
      handler = double('Handler', call: nil)

      expect(excon).to receive(:post).and_raise(Excon::Errors::Timeout)

      expect {
        ollama.upload_file(path: '/api/blobs/abc', body: body, handler: handler)
      }.to raise_error(Ollama::Errors::TimeoutError)
    end

    it 'can map generic Excon errors to Ollama::Errors::Error' do
      body = StringIO.new('dummy content')
      handler = double('Handler', call: nil)

      expect(excon).to receive(:post).and_raise(Excon::Error)

      expect {
        ollama.upload_file(path: '/api/blobs/abc', body: body, handler: handler)
      }.to raise_error(Ollama::Errors::Error)
    end
  end
end

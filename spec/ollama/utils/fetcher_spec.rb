require 'spec_helper'

RSpec.describe Ollama::Utils::Fetcher do
  let :url do
    'https://www.example.com/hello'
  end

  let :fetcher do
    described_class.new.expose
  end

  it 'can be instantiated' do
    expect(fetcher).to be_a described_class
  end

  it 'has .get' do
    expect(described_class).to receive(:new).and_return double(get: true)
    described_class.get(url)
  end

  it 'can #get with streaming' do
    stub_request(:get, 'https://www.example.com/hello').
      with(headers: fetcher.headers).
      to_return(
        status: 200,
        body: 'world',
        headers: { 'Content-Type' => 'text/plain' },
      )
    fetcher.get(url) do |tmp|
      expect(tmp).to be_a Tempfile
      expect(tmp.read).to eq 'world'
      expect(tmp.content_type).to eq 'text/plain'
    end
  end

  it 'can #get without ssl peer verification' do
    fetcher = described_class.new(
      http_options: { ssl_verify_peer: false }
    ).expose
    stub_request(:get, 'https://www.example.com/hello').
      with(headers: fetcher.headers).
      to_return(
        status: 200,
        body: 'world',
        headers: { 'Content-Type' => 'text/plain' },
      )
    expect(Excon).to receive(:new).with(
      'https://www.example.com/hello',
      hash_including(ssl_verify_peer: false)
    ).and_call_original
    fetcher.get(url) do |tmp|
      expect(tmp).to be_a Tempfile
      expect(tmp.read).to eq 'world'
      expect(tmp.content_type).to eq 'text/plain'
    end
  end

  it 'can #get and fallback from streaming' do
    stub_request(:get, 'https://www.example.com/hello').
      with(headers: fetcher.headers).
      to_return(
        { status: 501 },
        {
          status: 200,
          body: 'world',
          headers: { 'Content-Type' => 'text/plain' },
        }
      )
    fetcher.get(url) do |tmp|
      expect(tmp).to be_a Tempfile
      expect(tmp.read).to eq 'world'
      expect(tmp.content_type).to eq 'text/plain'
    end
  end

  it 'can #get and finally fail' do
    stub_request(:get, 'https://www.example.com/hello').
      with(headers: fetcher.headers).
      to_return(status: 500)
    fetcher.get(url) do |tmp|
      expect(tmp).to be_a StringIO
      expect(tmp.read).to eq ''
      expect(tmp.content_type).to eq 'text/plain'
    end
  end

  it 'can redirect' do
    expect(fetcher.middlewares).to include Excon::Middleware::RedirectFollower
  end

  it 'can .read' do
    described_class.read(__FILE__) do |file|
      expect(file).to be_a File
      expect(file.read).to include 'can .read'
      expect(file.content_type).to eq 'application/x-ruby'
    end
  end

  it 'can .execute' do
    described_class.execute('echo -n hello world') do |file|
      expect(file).to be_a Tempfile
      expect(file.read).to eq 'hello world'
      expect(file.content_type).to eq 'text/plain'
    end
  end

  it 'can .execute and fail' do
    allow(IO).to receive(:popen).and_raise StandardError
    described_class.execute('foobar') do |file|
      expect(file).to be_a StringIO
      expect(file.read).to be_empty
      expect(file.content_type).to eq 'text/plain'
    end
  end
end

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
    stub_request(:get, url).
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
    stub_request(:get, url).
      with(headers: fetcher.headers).
      to_return(
        status: 200,
        body: 'world',
        headers: { 'Content-Type' => 'text/plain' },
      )
    expect(Excon).to receive(:new).with(
      url,
      hash_including(ssl_verify_peer: false)
    ).and_call_original
    fetcher.get(url) do |tmp|
      expect(tmp).to be_a Tempfile
      expect(tmp.read).to eq 'world'
      expect(tmp.content_type).to eq 'text/plain'
    end
  end

  it 'can #get and fallback from streaming' do
    stub_request(:get, url).
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
    stub_request(:get, url).
      with(headers: fetcher.headers).
      to_return(status: 500)
    expect(STDERR).to receive(:puts).with(/cannot.*get.*#{url}/i)
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
    expect(IO).to receive(:popen).and_raise StandardError
    expect(STDERR).to receive(:puts).with(/cannot.*execute.*foobar/i)
    described_class.execute('foobar') do |file|
      expect(file).to be_a StringIO
      expect(file.read).to be_empty
      expect(file.content_type).to eq 'text/plain'
    end
  end

  describe '.normalize_url' do
    it 'can handle umlauts' do
      expect(described_class.normalize_url('https://foo.de/bär')).to eq(
        'https://foo.de/b%C3%A4r'
      )
    end

    it 'can handle escaped umlauts' do
      expect(described_class.normalize_url('https://foo.de/b%C3%A4r')).to eq(
        'https://foo.de/b%C3%A4r'
      )
    end

    it 'can remove #anchors' do
      expect(described_class.normalize_url('https://foo.de#bar')).to eq(
        'https://foo.de'
      )
    end
  end
end

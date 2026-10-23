describe Ollama do
  describe '.base_url' do
    context 'with a bare host:port string' do
      it 'prepends http://' do
        result = Ollama.base_url('127.0.0.1:11434')
        expect(result).to be_a(URI::HTTP)
        expect(result.to_s).to eq('http://127.0.0.1:11434')
      end

      it 'works with a hostname' do
        result = Ollama.base_url('localhost:11434')
        expect(result.to_s).to eq('http://localhost:11434')
      end
    end

    context 'with a fully-qualified http URL' do
      it 'returns the URI unchanged' do
        result = Ollama.base_url('http://127.0.0.1:11434')
        expect(result).to be_a(URI::HTTP)
        expect(result.to_s).to eq('http://127.0.0.1:11434')
      end

      it 'preserves the path' do
        result = Ollama.base_url('http://127.0.0.1:11434/v1')
        expect(result.to_s).to eq('http://127.0.0.1:11434/v1')
      end
    end

    context 'with a fully-qualified https URL' do
      it 'returns the URI unchanged' do
        result = Ollama.base_url('https://mybox.example.com:8443/v1')
        expect(result).to be_a(URI::HTTPS)
        expect(result.to_s).to eq('https://mybox.example.com:8443/v1')
      end
    end

    context 'with a URI object' do
      it 'returns the same object for http' do
        uri = URI.parse('http://127.0.0.1:11434')
        expect(Ollama.base_url(uri)).to be(uri)
      end

      it 'returns the same object for https' do
        uri = URI.parse('https://secure.example.com')
        expect(Ollama.base_url(uri)).to be(uri)
      end
    end

    context 'with fallback: false' do
      it 'returns nil when scheme is not http(s)' do
        expect(Ollama.base_url('localhost:11434', fallback: false))
          .to be_nil
      end

      it 'still returns the URI when scheme is http' do
        result = Ollama.base_url('http://127.0.0.1:11434', fallback: false)
        expect(result.to_s).to eq('http://127.0.0.1:11434')
      end
    end
  end
end

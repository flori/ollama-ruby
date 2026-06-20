require 'stringio'

describe Ollama::Digester do
  # Since compute_digest is private, we create a test class to include it
  let :test_class do
    Class.new do
      include Ollama::Digester

      def digest(io, **args)
        compute_digest(io, **args)
      end
    end
  end

  let(:digester) { test_class.new }

  let(:content)  { 'Hello, Ruby happiness! 🍓' }

  let(:io)       { StringIO.new(content) }

  describe '#compute_digest' do
    it 'calculates the correct SHA256 digest with the required prefix' do
      expected_hash = "sha256:#{Digest::SHA256.hexdigest(content)}"
      expect(digester.digest(io)).to eq(expected_hash)
    end

    it 'rewinds the IO object before starting if it is not at the beginning' do
      io.seek(content.length / 2) # Move pointer to the middle

      # If it didn't rewind, it would only hash the second half
      expected_hash = "sha256:#{Digest::SHA256.hexdigest(content)}"
      expect(digester.digest(io)).to eq(expected_hash)
    end

    it 'leaves the IO object rewound after processing' do
      digester.digest(io)
      expect(io.pos).to eq(0)
    end

    it 'works correctly when using a very small chunk size' do
      # Force many iterations of the loop by using 1-byte chunks
      expected_hash = "sha256:#{Digest::SHA256.hexdigest(content)}"
      expect(digester.digest(io, chunk_size: 1)).to eq(expected_hash)
    end

    it 'handles empty streams correctly' do
      empty_io = StringIO.new('')
      expected_hash = "sha256:#{Digest::SHA256.hexdigest('')}"
      expect(digester.digest(empty_io)).to eq(expected_hash)
    end

    it 'ensures the IO is rewound even if an error occurs during hashing' do
      io.seek(content.length / 2) # Move pointer to the middle

      # Mock Digest to raise an error
      allow(Digest::SHA256).to receive(:new).and_raise(StandardError, 'Hashing failed')

      expect { digester.digest(io) }.to raise_error(StandardError, 'Hashing failed')
      expect(io.pos).to eq(0)
    end
  end
end

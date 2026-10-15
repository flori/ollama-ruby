describe Ollama::Options do
  let :options do
    described_class.new(
      penalize_newline: true,
      num_ctx: 8192,
      temperature: 0.7,
    )
  end

  it 'can be instantiated' do
    expect(options).to be_a described_class
  end

  it 'can be configured by loading from JSON' do
    options = described_class.load_from_json(asset('options.json'))
    expect(options).to be_a described_class
    expect(options.num_ctx).to eq(16384)
    expect(options.seed).to eq(-1)
    expect(options.num_predict).to eq(1024)
    expect(options.temperature).to be_within(1E-6).of(0.666)
    expect(options.top_p).to be_within(0.001).of(0.95)
    expect(options.min_p).to be_within(0.001).of(0.1)
  end

  it 'can be empty' do
    expect(described_class.new).to be_empty
  end

  it 'can be used to cast hashes' do
    expect(described_class[{
      penalize_newline: true,
      num_ctx: 8192,
      temperature: 0.7,
    }]).to be_a described_class
  end

  it 'raises errors when casting goes all wrong' do
    expect {
      described_class[{
        penalize_newline: :tertium,
        num_ctx: 8192,
        temperature: 0.7,
      }]
    }.to raise_error(TypeError)
  end

  it 'throws error for invalid types' do
    expect { described_class.new(temperature: Class.new) }.
      to raise_error(TypeError)
  end

  it 'throws error for invalid boolean values' do
    expect { described_class.new(penalize_newline: :tertium) }.
      to raise_error(TypeError)
  end

  context '.from_string' do
    it 'parses boolean values' do
      result = described_class.from_string("use_mmap true\nuse_mlock false")
      expect(result.use_mmap).to be true
      expect(result.use_mlock).to be false
    end

    it 'parses integer values' do
      result = described_class.from_string("num_ctx 8192\nnum_batch 512")
      expect(result.num_ctx).to eq(8192)
      expect(result.num_batch).to eq(512)
    end

    it 'parses negative integers' do
      result = described_class.from_string("num_predict -1")
      expect(result.num_predict).to eq(-1)
    end

    it 'parses float values' do
      result = described_class.from_string("temperature 0.7\ntop_p 0.95")
      expect(result.temperature).to be_within(1e-6).of(0.7)
      expect(result.top_p).to be_within(1e-6).of(0.95)
    end

    it 'accumulates array values for multi-line keys' do
      result = described_class.from_string(<<~EOS)
        stop <|start_header_id|>
        stop <|end_header_id|>
        stop <|eot_id|>
      EOS
      expect(result.stop).to eq(
        ['<|start_header_id|>', '<|end_header_id|>', '<|eot_id|>']
      )
    end

    it 'handles mixed types in a single block' do
      result = described_class.from_string(<<~EOS)
        use_mmap true
        num_ctx 4096
        temperature 0.8
        stop end
      EOS
      expect(result.use_mmap).to be true
      expect(result.num_ctx).to eq(4096)
      expect(result.temperature).to be_within(1e-6).of(0.8)
      expect(result.stop).to eq(['end'])
    end

    it 'skips unparseable lines gracefully' do
      result = described_class.from_string("temperature 0.7\ngarbage hello")
      expect(result.temperature).to be_within(1e-6).of(0.7)
    end
  end
end

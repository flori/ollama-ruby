require 'spec_helper'

RSpec.describe Ollama::Utils::Width do
  before do
    allow(Tins::Terminal).to receive(:columns).and_return 80
  end

  describe '.width' do
    it 'defaults to 100%' do
      expect(described_class.width).to eq 80
    end

    it 'can be to 80%' do
      expect(described_class.width(percentage: 80)).to eq 64
    end
  end

  describe '.wrap' do
    it 'can wrap with percentage' do
      wrapped = described_class.wrap([ ?A * 10 ] * 10 * ' ', percentage: 80)
      expect(wrapped).to eq(
        "AAAAAAAAAA AAAAAAAAAA AAAAAAAAAA AAAAAAAAAA AAAAAAAAAA\n"\
        "AAAAAAAAAA AAAAAAAAAA AAAAAAAAAA AAAAAAAAAA AAAAAAAAAA"
      )
      expect(wrapped.size).to eq 109
    end

    it 'can wrap with length' do
      wrapped = described_class.wrap([ ?A * 10 ] * 10 * ' ', length: 64)
      expect(wrapped).to eq(
        "AAAAAAAAAA AAAAAAAAAA AAAAAAAAAA AAAAAAAAAA AAAAAAAAAA\n"\
        "AAAAAAAAAA AAAAAAAAAA AAAAAAAAAA AAAAAAAAAA AAAAAAAAAA"
      )
      expect(wrapped.size).to eq 109
    end

    it "doesn't wrap with length 0" do
      wrapped = described_class.wrap([ ?A * 10 ] * 10 * ' ', length: 0)
      expect(wrapped).to eq(
        "AAAAAAAAAA AAAAAAAAAA AAAAAAAAAA AAAAAAAAAA AAAAAAAAAA "\
        "AAAAAAAAAA AAAAAAAAAA AAAAAAAAAA AAAAAAAAAA AAAAAAAAAA"
      )
    end
  end

  describe '.truncate' do
    it 'can truncate with percentage' do
      truncated = described_class.truncate([ ?A * 10 ] * 10 * ' ', percentage: 80)
      expect(truncated).to eq(
        "AAAAAAAAAA AAAAAAAAAA AAAAAAAAAA AAAAAAAAAA AAAAAAAAAA AAAAAAAA…"
      )
      expect(truncated.size).to eq 64
    end

    it 'can truncate with length' do
      truncated = described_class.truncate([ ?A * 10 ] * 10 * ' ', length: 64)
      expect(truncated).to eq(
        "AAAAAAAAAA AAAAAAAAAA AAAAAAAAAA AAAAAAAAAA AAAAAAAAAA AAAAAAAA…"
      )
      expect(truncated.size).to eq 64
    end

    it 'cannot truncate if not necessary' do
      text = [ ?A * 10 ] * 5 * ' '
      truncated = described_class.truncate(text, length: 54)
      expect(truncated).to eq text
    end

    it 'can truncate with length 0' do
      truncated = described_class.truncate([ ?A * 10 ] * 10 * ' ', length: 0)
      expect(truncated).to be_empty
    end

    it 'can truncate with ...' do
      truncated = described_class.truncate([ ?A * 10 ] * 10 * ' ', length: 64, ellipsis: '...')
      expect(truncated).to eq(
        "AAAAAAAAAA AAAAAAAAAA AAAAAAAAAA AAAAAAAAAA AAAAAAAAAA AAAAAA..."
      )
      expect(truncated.size).to eq 64
    end
  end
end

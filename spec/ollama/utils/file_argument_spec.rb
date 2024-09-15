require 'spec_helper'

RSpec.describe Ollama::Utils::FileArgument do
  it 'it can return content' do
    expect(described_class.get_file_argument('foo')).to eq 'foo'
  end

  it 'it can return content at path' do
    expect(described_class.get_file_argument(asset('prompt.txt'))).to include\
      'test prompt'
  end

  it 'it can return default content' do
    expect(described_class.get_file_argument('', default: 'foo')).to eq 'foo'
    expect(described_class.get_file_argument(nil, default: 'foo')).to eq 'foo'
  end
end

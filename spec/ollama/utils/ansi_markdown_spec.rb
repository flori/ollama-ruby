require 'spec_helper'

RSpec.describe Ollama::Utils::ANSIMarkdown do
  let :source  do
    File.read(Pathname.new(__dir__) + '..' + '..' + '..' + 'README.md')
  end

  it 'can parse' do
    File.open('tmp/README.ansi', ?w) do |output|
      ansi = described_class.parse(source)
      expect(ansi).to match("This is the end.")
      output.puts ansi
    end
  end
end

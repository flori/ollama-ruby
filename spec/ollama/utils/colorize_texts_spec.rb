require 'spec_helper'

RSpec.describe Ollama::Utils::ColorizeTexts do
  it 'colorizes texts' do
    ct = described_class.new(%w[ foo bar ])
    colored   = ct.to_s
    uncolored = Term::ANSIColor.uncolor(ct.to_s)
    expect(colored.size).to be > uncolored.size
    expect(uncolored).to eq(
      "foo\n#3 \n\nbar\n#3 \n\n"
    )
  end
end

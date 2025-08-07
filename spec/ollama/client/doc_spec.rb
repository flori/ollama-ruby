require 'spec_helper'

describe Ollama::Client::Doc do
  it 'can document commands' do
    expect(Ollama::Client::Doc.new(:generate).to_s).to match(/generate-a-completion/)
  end

  it 'defaults to the whole API document' do
    expect(Ollama::Client::Doc.new(:nix).to_s).to match(%r(main/docs/api.md))
  end
end

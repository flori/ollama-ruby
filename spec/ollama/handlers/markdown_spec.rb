require 'spec_helper'

RSpec.describe Ollama::Handlers::Markdown do
  it 'has .call' do
    expect_any_instance_of(described_class).to receive(:call).with(:foo)
    described_class.call(:foo)
  end

  let :md do
    <<~end
      - **strong**
      - *emphasized*
    end
  end

  let :ansi do
    <<~end
    · \e[1mstrong\e[0m

    · \e[3memphasized\e[0m

    end
  end

  it 'can markdown response as markdown' do
    output = double('output', :sync= => true)
    expect(output).to receive(:print).with("\e[2J", "\e[1;1H", ansi)
    markdown = described_class.new(output:)
    response = double('response', response: md, done: false)
    markdown.call(response)
    response = double('response', response: nil, message: nil, done: true)
    markdown.call(response)
  end

  it 'can markdown message content as markdown' do
    output = double('output', :sync= => true)
    expect(output).to receive(:print).with("\e[2J", "\e[1;1H", ansi)
    markdown = described_class.new(output:)
    response = double('response', response: nil, message: double(content: md), done: false)
    markdown.call(response)
    response = double('response', response: nil, message: nil, done: true)
    markdown.call(response)
  end
end

require 'spec_helper'

describe Ollama::Handlers::Say do
  let :say do
    described_class.new
  end

  it 'has .to_proc' do
    expect_any_instance_of(described_class).to receive(:call).with(:foo)
    described_class.call(:foo)
  end

  it 'can be instantiated' do
    expect(say).to be_a described_class
  end

  it 'can be instantiated with a given voice' do
    expect_any_instance_of(described_class).to receive(:command).
      with(hash_including(voice: 'TheVoice')).and_return %w[ true ]
    say = described_class.new(voice: 'TheVoice')
    expect(say).to be_a described_class
  end

  describe 'command' do
    it 'can be instantiated interactively' do
      expect_any_instance_of(described_class).to receive(:command).
        with(hash_including(interactive: true)).and_return %w[ true ]
      say = described_class.new(interactive: true)
      expect(say).to be_a described_class
    end

    it 'can set the voice' do
      expect(say.send(:command, voice: 'TheVoice', interactive: nil)).to eq(
        %w[ say -v TheVoice ]
      )
    end

    it 'can be instantiated interactively with green' do
      expect_any_instance_of(described_class).to receive(:command).
        with(hash_including(interactive: 'green')).and_return %w[ true ]
      say = described_class.new(interactive: 'green')
      expect(say).to be_a described_class
    end

    it 'can set interactive mode' do
      expect(say.send(:command, voice: nil, interactive: true)).to eq(
        %w[ say -i ]
      )
    end

    it 'can set interactive mode to green' do
      expect(say.send(:command, voice: nil, interactive: 'green')).to eq(
        %w[ say --interactive=green ]
      )
    end
  end

  it 'can say response' do
    output = double('output', :sync= => true, closed?: false)
    expect(output).to receive(:print).with('testing')
    expect(output).to receive(:close)
    say = described_class.new(output:)
    response = double('response', response: 'testing', done: false)
    say.call(response)
    response = double('response', response: nil, message: nil, done: true)
    say.call(response)
  end

  it 'can say message content' do
    output = double('output', :sync= => true, closed?: false)
    expect(output).to receive(:print).with('testing')
    expect(output).to receive(:close)
    say = described_class.new(output:)
    response = double('response', response: nil, message: double(content: 'testing'), done: false)
    say.call(response)
    response = double('response', response: nil, message: nil, done: true)
    say.call(response)
  end

  it 'can reopen output if closed' do
    output = double('output', :sync= => true, closed?: true)
    reopened_output = double('output', :sync= => true, closed?: false, pid: 666)
    expect(reopened_output).to receive(:print).with('testing')
    expect(reopened_output).to receive(:close)
    say = described_class.new(output:)
    expect(say).to receive(:open_output).and_return(reopened_output)
    response = double('response', response: 'testing', done: false)
    say.call(response)
    response = double('response', response: nil, message: nil, done: true)
    say.call(response)
  end

end

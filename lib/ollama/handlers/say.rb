require 'shellwords'

class Ollama::Handlers::Say
  include Ollama::Handlers::Concern

  def initialize(output: nil, voice: 'Samantha')
    output ||= IO.popen(Shellwords.join([ 'say', '-v', voice ]), 'w')
    super(output:)
    @output.sync = true
  end

  def call(response)
    if content = response.response || response.message&.content
      @output.print content
    end
    response.done and @output.close
    self
  end
end

require 'shellwords'

class Ollama::Handlers::Say
  include Ollama::Handlers::Concern

  def initialize(output: nil, voice: 'Samantha', interactive: nil)
    output ||= IO.popen(Shellwords.join(command(voice:, interactive:)), 'w')
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

  private

  def command(voice:, interactive:)
    command = [ 'say' ]
    voice and command.concat([ '-v', voice ])
    case interactive
    when true
      command << '-i'
    when String
      command << '--interactive=%s' % interactive
    end
    command
  end
end

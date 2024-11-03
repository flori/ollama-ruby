require 'shellwords'

class Ollama::Handlers::Say
  include Ollama::Handlers::Concern

  def initialize(output: nil, voice: 'Samantha', interactive: nil)
    @voice       = voice
    @interactive = interactive
    super(output:)
    unless output
      @output = open_output
      @output_pid = @output.pid
    end
  end

  attr_reader :voice

  attr_reader :interactive

  def call(response)
    if @output.closed?
      wait_output_pid
      @output     = open_output
      @output_pid = @output.pid
    end
    if content = response.response || response.message&.content
      @output.print content
    end
    response.done and @output.close
    self
  end

  private

  def open_output
    io = IO.popen(Shellwords.join(command(voice:, interactive:)), 'w')
    io.sync = true
    io
  end

  def wait_output_pid
    @output_pid or return
    Process.wait(@output_pid, Process::WNOHANG | Process::WUNTRACED)
  rescue Errno::ECHILD
  end

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

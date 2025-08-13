require 'shellwords'

# A handler that uses the system's say command to speak response content.
#
# The Say handler is designed to convert text responses from Ollama API
# commands into audible speech using the operating system's native
# text-to-speech capabilities. It supports customization of voice and
# interactive modes, making it suitable for applications where audio feedback
# is preferred over visual display.
#
# @example Using the Say handler with a custom voice
#   ollama.generate(model: 'llama3.1', prompt: 'Hello World', &Say.new(voice: 'Alex'))
#
# @example Using the Say handler in interactive mode
#   ollama.generate(model: 'llama3.1', prompt: 'Hello World', &Say.new(interactive: true))
class Ollama::Handlers::Say
  include Ollama::Handlers::Concern

  # The initialize method sets up a new handler instance with the specified
  # output destination and configures voice and interactive settings for
  # text-to-speech functionality.
  #
  # @param output [ IO, nil ] the output stream to be used for handling responses, defaults to nil
  # @param voice [ String ] the voice to be used for speech synthesis, defaults to 'Samantha'
  # @param interactive [ TrueClass, FalseClass, String, nil ] the interactive
  # mode setting for speech synthesis, defaults to nil
  def initialize(output: nil, voice: 'Samantha', interactive: nil)
    @voice       = voice
    @interactive = interactive
    super(output:)
    unless output
      @output = open_output
      @output_pid = @output.pid
    end
  end

  # The voice attribute reader returns the voice associated with the object.
  #
  # @return [ String ] the voice value stored in the instance variable
  attr_reader :voice

  # The interactive attribute reader returns the interactive mode setting
  # associated with the object.
  #
  # @return [ TrueClass, FalseClass, String, nil ] the interactive mode value
  # stored in the instance variable
  attr_reader :interactive

  # The call method processes a response by printing its content to the output stream.
  #
  # This method handles the display of response content by extracting text from the response object
  # and writing it to the configured output stream. It manages the output stream state, reopening it
  # if necessary when it has been closed, and ensures proper handling of streaming responses by
  # closing the output stream when the response indicates completion.
  #
  # @param response [ Ollama::Response ] the response object containing content to be printed
  #
  # @return [ self ] returns the handler instance itself after processing the response
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

  # The open_output method creates a new IO object for handling speech output.
  #
  # This method initializes a pipe to the system's say command, configuring it
  # with the specified voice and interactive settings. It returns an IO object
  # that can be used to write text content which will be converted to speech by
  # the operating system.
  #
  # @return [ IO ] an IO object connected to the say command for text-to-speech conversion
  def open_output
    io = IO.popen(Shellwords.join(command(voice:, interactive:)), 'w')
    io.sync = true
    io
  end

  # The wait_output_pid method waits for the output process to complete.
  #
  # This method checks if there is an active output process ID and waits for it
  # to finish execution. It uses non-blocking wait to avoid hanging the main
  # thread.
  # If the process has already terminated, it handles the Errno::ECHILD
  # exception gracefully without raising an error.
  def wait_output_pid
    @output_pid or return
    Process.wait(@output_pid, Process::WNOHANG | Process::WUNTRACED)
  rescue Errno::ECHILD
  end

  # The command method constructs a say command array with specified voice and
  # interactive options.
  #
  # This method builds an array representing a system command for the 'say'
  # utility, incorporating the provided voice and interactive settings to
  # configure text-to-speech behavior.
  #
  # @param voice [ String ] the voice to be used for speech synthesis
  # @param interactive [ TrueClass, FalseClass, String, nil ] the interactive
  # mode setting for speech synthesis
  #
  # @return [ Array<String> ] an array containing the command and its arguments
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

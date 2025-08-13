# A handler that prints response content to the output stream.
#
# The Print handler is designed to output text responses from Ollama API
# commands to a specified output stream. It extracts content from responses and
# displays it directly, making it useful for interactive terminal applications
# where immediate feedback is desired.
#
# @example Using the Print handler with a chat command
#   ollama.chat(model: 'llama3.1', messages:, &Print)
#
# @example Using the Print handler with a generate command
#   ollama.generate(model: 'llama3.1', prompt: 'Hello World', &Print)
class Ollama::Handlers::Print
  include Ollama::Handlers::Concern

  # The initialize method sets up a new handler instance with the specified
  # output destination and enables synchronous writing to the output stream.
  #
  # @param output [ IO ] the output stream to be used for handling responses, defaults to $stdout
  def initialize(output: $stdout)
    super
    @output.sync = true
  end

  # The call method processes a response by printing its content to the output
  # stream.
  #
  # This method extracts content from the response object and prints it to the
  # configured output stream. If the response indicates completion, it adds a
  # newline character after printing. The method returns the handler instance
  # itself to allow for method chaining.
  #
  # @param response [ Ollama::Response ] the response object to be processed
  #
  # @return [ self ] returns the handler instance after processing the response
  def call(response)
    if content = response.response || response.message&.content
      @output.print content
    end
    response.done and @output.puts
    self
  end
end

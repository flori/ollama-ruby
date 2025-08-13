# A handler that performs no operation on responses.
#
# The NOP (No Operation) handler is used when it's necessary to pass a handler
# object to a command without actually processing or displaying the responses.
# It implements the required interface for response handling but takes no
# action when called, making it useful for scenarios where a handler is
# required by the API but no specific processing is desired.
#
# @example Using the NOP handler
#   ollama.generate(model: 'llama3.1', prompt: 'Hello World', &NOP)
class Ollama::Handlers::NOP
  include Ollama::Handlers::Concern

  # The call method processes a response and returns the handler instance.
  #
  # This method is intended to be overridden by concrete handler
  # implementations to define specific behavior for handling API responses. It
  # serves as the core interface for response processing within the handler
  # pattern.
  #
  # @param response [ Ollama::Response ] the response object to be processed by the handler
  #
  # @return [ self ] returns the handler instance itself after processing the response
  def call(response)
    self
  end
end

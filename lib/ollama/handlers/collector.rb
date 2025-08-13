# A handler that collects responses into an array and returns the array as the result.
#
# The Collector handler is designed to accumulate all responses during command execution
# and provide access to the complete collection of responses through its result method.
# It is typically used when multiple responses are expected and need to be processed
# together rather than individually.
#
# @example Using the Collector handler to gather all responses
#   responses = ollama.generate(model: 'llama3.1', prompt: 'Hello World', &Collector)
#   # responses will contain an array of all response objects received
class Ollama::Handlers::Collector
  include Ollama::Handlers::Concern

  # The initialize method sets up a new handler instance with the specified
  # output destination and initializes an empty array for collecting responses.
  #
  # @param output [ IO ] the output stream to be used for handling responses,
  # defaults to $stdout
  def initialize(output: $stdout)
    super
    @array = []
  end

  # The call method processes a response by appending it to an internal array.
  #
  # This method is responsible for handling individual responses during command
  # execution by storing them in an internal array for later retrieval. It
  # supports method chaining by returning the handler instance itself after
  # processing.
  #
  # @param response [ Ollama::Response ] the response object to be processed and stored
  #
  # @return [ self ] returns the handler instance itself after processing the response
  def call(response)
    @array << response
    self
  end

  # The result method returns the collected response data from handler
  # operations.
  #
  # This method provides access to the accumulated results after a command has
  # been executed with a handler that collects responses. It returns the
  # internal array containing all responses that were processed by the handler.
  #
  # @return [ Array<Ollama::Response>, nil ] the array of collected response objects,
  #         or nil if no responses were collected
  def result
    @array
  end
end

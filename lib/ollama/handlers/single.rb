# A handler that collects responses and returns either a single response or an
# array of responses.
#
# The Single handler is designed to accumulate responses during command
# execution and provides a result that is either the single response when only
# one is present, or the complete array of responses when multiple are
# collected.
#
# @example Using the Single handler to collect a single response
#   ollama.generate(model: 'llama3.1', prompt: 'Hello World', &Single)
class Ollama::Handlers::Single
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

  # The result method returns the collected response data from handler operations.
  #
  # This method provides access to the accumulated results after a command has
  # been executed with a handler that collects responses. It returns either
  # a single response when only one result is present, or the complete array
  # of responses when multiple results are collected.
  #
  # @return [ Ollama::Response, Array<Ollama::Response>, nil ] the collected response data,
  #         which may be a single response, an array of responses, or nil
  #         if no responses were collected
  def result
    @array.size <= 1 ? @array.first : @array
  end
end

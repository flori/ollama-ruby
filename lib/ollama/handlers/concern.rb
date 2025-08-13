require 'tins/concern'
require 'tins/implement'

# A module that defines the common interface and behavior for all response
# handlers used with Ollama client commands.
#
# Handlers are responsible for processing responses from the Ollama API
# according to specific logic, such as printing output, collecting results, or
# displaying progress. This module establishes the foundational structure that
# all handler classes must implement to be compatible with the client's command
# execution flow.
module Ollama::Handlers::Concern
  extend Tins::Concern
  extend Tins::Implement

  # The initialize method sets up a new handler instance with the specified
  # output destination.
  #
  # @param output [ IO ] the output stream to be used for handling responses, defaults to $stdout
  def initialize(output: $stdout)
    @output = output
  end

  # The output attribute reader returns the output stream used by the client.
  #
  # @return [ IO ] the output stream, typically $stdout, to which responses and
  #         messages are written
  attr_reader :output

  # The result method returns the collected response data from handler operations.
  #
  # This method provides access to the accumulated results after a command has
  # been executed with a handler that collects responses, such as Collector or
  # Single handlers.
  #
  # @return [ Ollama::Response, Array<Ollama::Response>, nil ] the result of the handler operation,
  #         which may be a single response, an array of responses, or nil
  #         depending on the handler type and the command execution
  attr_reader :result


  # The implement :call, :subclass line enforces that any class including this
  # concern must implement a `call` instance method. This creates a contract
  # that ensures all handler implementations will have the required interface
  # for processing Ollama API responses. The :subclass parameter indicates this
  # validation occurs at the subclass level rather than the module level,
  # meaning concrete classes inheriting from this concern must provide their
  # own implementation of the call method. This is a form of compile-time
  # interface checking that helps prevent runtime errors when handlers are
  # expected to be callable with response objects.
  implement :call, :subclass

  # The to_proc method converts the handler instance into a proc object.
  #
  # This method returns a lambda that takes a response parameter and calls the
  # handler's call method with that response, enabling the handler to be used
  # in contexts where a proc is expected.
  #
  # @return [ Proc ] a proc that wraps the handler's call method for response
  # processing
  def to_proc
    -> response { call(response) }
  end

  class_methods do
    # The call method invokes the handler's call method with the provided
    # response.
    #
    # @param response [ Ollama::Response ] the response object to be processed by the
    # handler
    #
    # @return [ self ] returns the handler instance itself after processing the
    # response
    def call(response)
      new.call(response)
    end

    # The to_proc method converts the handler class into a proc object.
    #
    # This method creates a new instance of the handler and returns its to_proc
    # representation, enabling the handler class to be used in contexts where a
    # proc is expected.
    #
    # @return [ Proc ] a proc that wraps the handler's call method for response processing
    def to_proc
      new.to_proc
    end
  end
end

# A module that provides command definition capabilities for the Ollama client.
#
# This module extends the client with the ability to define and execute API
# commands by creating method definitions that correspond to Ollama API
# endpoints. It handles the creation of command methods with appropriate
# default and streaming handlers, and manages the execution flow for these
# commands.
#
# @example Defining a custom command
#   class MyClient
#     include Ollama::Client::Command
#     command(:custom, default_handler: Single, stream_handler: Collector)
#   end
module Ollama::Client::Command
  extend Tins::Concern

  class_methods do
    # Creates a command method for the Ollama client
    #
    # Defines a new command method that corresponds to an Ollama API endpoint.
    # The command method can be invoked with parameters and an optional handler
    # to process responses. It determines which handler to use based on whether
    # the command supports streaming and the presence of an explicit handler.
    #
    # @param name [ Symbol ] the name of the command to define
    # @param default_handler [ Class ] the default handler class to use when no explicit handler is provided
    # @param stream_handler [ Class, nil ] the handler class to use for streaming responses, if applicable
    #
    # @note Create Command `name`, if `stream` was true, set `stream_handler`
    # as default, otherwise `default_handler`.
    #
    # @return [ self ] returns the receiver after defining the command method
    def command(name, default_handler:, stream_handler: nil)
      klass = Ollama::Commands.const_get(name.to_s.camelize)
      doc Ollama::Client::Doc.new(name)
      define_method(name) do |**parameters, &handler|
        instance = klass.new(**parameters)
        instance.client = self
        unless handler
          instance.stream and stream_handler and
            handler ||= stream_handler
          handler ||= default_handler
        end
        handler.is_a?(Class) and handler = handler.new
        instance.perform(handler)
        handler.result if handler.respond_to?(:result)
      end
      self
    end
  end
end

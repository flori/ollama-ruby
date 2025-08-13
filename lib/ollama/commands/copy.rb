# A command class that represents the copy API endpoint for Ollama.
#
# This class is used to interact with the Ollama API's copy endpoint, which
# creates a copy of an existing model with a new name. It inherits from the base
# command structure and provides the necessary functionality to execute copy
# requests for model duplication.
#
# @example Copying a model to a new name
#   copy = ollama.copy(source: 'llama3.1', destination: 'user/llama3.1')
class Ollama::Commands::Copy
  include Ollama::DTO

  # The path method returns the API endpoint path for copy requests.
  #
  # This class method provides the specific URL path used to interact with the
  # Ollama API's copy endpoint. It is utilized internally by the command
  # structure to determine the correct API route for duplicating models.
  #
  # @return [ String ] the API endpoint path '/api/copy' for copy requests
  def self.path
    '/api/copy'
  end

  # The initialize method sets up a new instance with streaming disabled.
  #
  # This method is responsible for initializing a new object instance and
  # configuring it with the source and destination model names. It explicitly
  # disables streaming since copy operations are typically non-streaming.
  #
  # @param source [ String ] the name of the source model to be copied
  # @param destination [ String ] the name of the new model to be created
  def initialize(source:, destination:)
    @source, @destination, @stream = source, destination, false
  end

  # The source attribute reader returns the source model name associated with the object.
  #
  # @return [ String ] the name of the source model to be copied
  attr_reader :source

  # The destination attribute reader returns the destination model name associated with the object.
  #
  # @return [ String ] the name of the new model to be created
  attr_reader :destination

  # The stream attribute reader returns the streaming behavior setting
  # associated with the object.
  #
  # @return [ FalseClass ] the streaming behavior flag, indicating whether
  #         streaming is enabled for the command execution (always false for copy commands)
  attr_reader :stream

  # The client attribute writer allows setting the client instance associated
  # with the object.
  #
  # This method assigns the client that will be used to perform requests and
  # handle responses for this command. It is typically called internally when a
  # command is executed through a client instance.
  #
  # @attr_writer [ Ollama::Client ] the assigned client instance
  attr_writer :client

  # The perform method executes a command request using the specified handler.
  #
  # This method initiates a POST request to the Ollama API's copy endpoint,
  # utilizing the client instance to send the request and process responses
  # through the provided handler. It handles non-streaming scenarios since
  # copy commands do not support streaming.
  #
  # @param handler [ Ollama::Handler ] the handler object responsible for processing API
  # responses
  #
  # @return [ self ] returns the current instance after initiating the request
  def perform(handler)
    @client.request(method: :post, path: self.class.path, body: to_json, stream:, handler:)
  end
end

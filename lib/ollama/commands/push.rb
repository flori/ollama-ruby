# A command class that represents the push API endpoint for Ollama.
#
# This class is used to interact with the Ollama API's push endpoint, which
# uploads a model to a remote registry. It inherits from the base command
# structure and provides the necessary functionality to execute push requests
# for model deployment.
#
# @example Pushing a model to a remote registry
#   push = ollama.push(model: 'user/llama3.1')
class Ollama::Commands::Push
  include Ollama::DTO

  # The path method returns the API endpoint path for push requests.
  #
  # This class method provides the specific URL path used to interact with the
  # Ollama API's push endpoint. It is utilized internally by the command
  # structure to determine the correct API route for uploading models to a
  # remote registry.
  #
  # @return [ String ] the API endpoint path '/api/push' for push requests
  def self.path
    '/api/push'
  end

  # The initialize method sets up a new instance with streaming enabled by default.
  #
  # This method is responsible for initializing a new object instance and
  # configuring it with a default setting that enables streaming behavior.
  # It is typically called during the object creation process to establish
  # the initial state of the instance.
  #
  # @param model [ String ] the name of the model to be pushed
  # @param insecure [ TrueClass, FalseClass, nil ] whether to allow insecure
  #        connections, or nil to use default
  # @param stream [ TrueClass, FalseClass ] whether to enable streaming for
  #        the operation, defaults to true
  def initialize(model:, insecure: nil, stream: true)
    @model, @insecure, @stream = model, insecure, stream
  end

  # The model attribute reader returns the model name associated with the object.
  #
  # @return [ String ] the name of the model to be pushed
  attr_reader :model

  # The insecure attribute reader returns the insecure connection setting
  # associated with the object.
  #
  # @return [ TrueClass, FalseClass, nil ] the insecure flag indicating whether
  #         insecure connections are allowed, or nil if not set
  attr_reader :insecure

  # The stream attribute reader returns the streaming behavior setting
  # associated with the object.
  #
  # @return [ TrueClass, FalseClass ] the streaming behavior flag, indicating
  #         whether streaming is enabled for the command execution
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
  # This method initiates a request to the Ollama API endpoint associated with
  # the command, utilizing the client instance to send the request and process
  # responses through the provided handler. It handles both streaming and
  # non-streaming scenarios based on the command's configuration.
  #
  # @param handler [ Ollama::Handler ] the handler object responsible for processing API responses
  #
  # @return [ self ] returns the current instance after initiating the request
  def perform(handler)
    @client.request(method: :post, path: self.class.path, body: to_json, stream:, handler:)
  end
end

# A command class that represents the show API endpoint for Ollama.
#
# This class is used to interact with the Ollama API's show endpoint, which
# retrieves detailed information about a specific model. It inherits from the
# base command structure and provides the necessary functionality to execute
# show requests for model details.
#
# @example Retrieving detailed information about a model
#   show = ollama.show(model: 'llama3.1')
#   show.model_info # => hash containing model details
class Ollama::Commands::Show
  include Ollama::DTO

  # The path method returns the API endpoint path for show requests.
  #
  # This class method provides the specific URL path used to interact with the
  # Ollama API's show endpoint. It is utilized internally by the command
  # structure to determine the correct API route for retrieving detailed
  # information about a specific model.
  #
  # @return [ String ] the API endpoint path '/api/show' for show requests
  def self.path
    '/api/show'
  end

  # The initialize method sets up a new instance with streaming disabled.
  #
  # This method is responsible for initializing a new object instance and
  # configuring it with a default setting that disables streaming behavior.
  # It is typically called during the object creation process to establish
  # the initial state of the instance.
  #
  # @param model [ String ] the name of the model to be used @param verbose [
  # TrueClass, FalseClass, nil ] whether to enable verbose output, or nil to
  # use default
  def initialize(model:, verbose: nil)
    @model, @verbose = model, verbose
    @stream = false
  end

  # The model attribute reader returns the model name associated with the object.
  #
  # @return [ String ] the name of the model used by the command instance
  attr_reader :model

  # The verbose attribute reader returns the verbose setting associated with
  # the object.
  #
  # @return [ TrueClass, FalseClass, nil ] the verbose flag indicating whether
  #         verbose output is enabled, or nil if not set
  attr_reader :verbose

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

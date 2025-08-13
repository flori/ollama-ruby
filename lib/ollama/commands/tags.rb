# A command class that represents the tags API endpoint for Ollama.
#
# This class is used to interact with the Ollama API's tags endpoint, which
# retrieves information about locally available models. It inherits from the
# base command structure and provides the necessary functionality to execute
# tag listing requests.
#
# @example Retrieving a list of local models
#   tags = ollama.tags
#   tags.models # => array of model information hashes
class Ollama::Commands::Tags

  # The path method returns the API endpoint path for tag listing requests.
  #
  # This class method provides the specific URL path used to interact with the
  # Ollama API's tags endpoint. It is utilized internally by the command
  # structure to determine the correct API route for retrieving information
  # about locally available models.
  #
  # @return [ String ] the API endpoint path '/api/tags' for tag listing requests
  def self.path
    '/api/tags'
  end

  # The initialize method sets up a new instance with streaming disabled.
  #
  # This method is responsible for initializing a new object instance and
  # configuring it with a default setting that disables streaming behavior. It
  # is typically called during the object creation process to establish the
  # initial state of the instance.
  #
  # @param parameters [ Hash ] a hash containing initialization parameters
  def initialize(**parameters)
    parameters.empty? or raise ArgumentError,
      "Invalid parameters: #{parameters.keys * ' '}"
    @stream = false
  end

  # The stream attribute reader returns the streaming behavior setting
  # associated with the object.
  #
  # @return [ TrueClass, FalseClass ] the streaming behavior flag, indicating
  # whether streaming is enabled for the command execution
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
  # @param handler [ Ollama::Handlers ] the handler object responsible for processing API responses
  #
  # @return [ self ] returns the current instance after initiating the request
  def perform(handler)
    @client.request(method: :get, path: self.class.path, stream:, handler:)
  end
end

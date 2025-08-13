# A command class that represents the ps API endpoint for Ollama.
#
# This class is used to interact with the Ollama API's ps endpoint, which
# retrieves information about running models. It inherits from the base command
# structure and provides the necessary functionality to execute ps requests
# for monitoring active model processes.
#
# @example Retrieving information about running models
#   ps = ollama.ps
#   ps.models # => array of running model information
class Ollama::Commands::Ps
  # The path method returns the API endpoint path for ps requests.
  #
  # This class method provides the specific URL path used to interact with the
  # Ollama API's ps endpoint. It is utilized internally by the command
  # structure to determine the correct API route for retrieving information
  # about running models.
  #
  # @return [ String ] the API endpoint path '/api/ps' for ps requests
  def self.path
    '/api/ps'
  end

  # The initialize method sets up a new instance with streaming disabled.
  #
  # This method is responsible for initializing a new object instance and
  # configuring it with a default setting that disables streaming behavior.
  # It is typically called during the object creation process to establish
  # the initial state of the instance.
  #
  # @param parameters [ Hash ] a hash containing initialization parameters
  #                           (must be empty for this command)
  #
  # @raise [ ArgumentError ] if any parameters are provided (ps endpoint
  #                           does not accept parameters)
  def initialize(**parameters)
    parameters.empty? or raise ArgumentError,
      "Invalid parameters: #{parameters.keys * ' '}"
    @stream = false
  end

  # The stream attribute reader returns the streaming behavior setting
  # associated with the object.
  #
  # @return [ TrueClass, FalseClass ] the streaming behavior flag, indicating
  #         whether streaming is enabled for the command execution
  #         (always false for ps commands)
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
  # This method initiates a GET request to the Ollama API's ps endpoint,
  # utilizing the client instance to send the request and process responses
  # through the provided handler. It handles non-streaming scenarios since
  # ps commands do not support streaming.
  #
  # @param handler [ Ollama::Handler ] the handler object responsible for processing API
  # responses
  #
  # @return [ self ] returns the current instance after initiating the request
  def perform(handler)
    @client.request(method: :get, path: self.class.path, stream:, handler:)
  end
end

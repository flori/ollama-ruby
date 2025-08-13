# A command class that represents the delete API endpoint for Ollama.
#
# This class is used to interact with the Ollama API's delete endpoint, which
# removes a specified model from the local system. It inherits from the base
# command structure and provides the necessary functionality to execute delete
# requests for model removal.
#
# @example Deleting a local model
#   delete = ollama.delete(model: 'user/llama3.1')
class Ollama::Commands::Delete
  include Ollama::DTO

  # The path method returns the API endpoint path for delete requests.
  #
  # This class method provides the specific URL path used to interact with the
  # Ollama API's delete endpoint. It is utilized internally by the command
  # structure to determine the correct API route for removing models from local storage.
  #
  # @return [ String ] the API endpoint path '/api/delete' for delete requests
  def self.path
    '/api/delete'
  end

  # The initialize method sets up a new instance with streaming disabled.
  #
  # This method is responsible for initializing a new object instance and
  # configuring it with the model name to be deleted. It explicitly disables
  # streaming since delete operations are typically non-streaming.
  #
  # @param model [ String ] the name of the model to be deleted
  def initialize(model:)
    @model, @stream = model, false
  end

  # The model attribute reader returns the model name associated with the object.
  #
  # @return [ String ] the name of the model to be deleted
  attr_reader :model

  # The stream attribute reader returns the streaming behavior setting
  # associated with the object.
  #
  # @return [ FalseClass ] the streaming behavior flag, indicating whether
  #         streaming is enabled for the command execution (always false for delete commands)
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
  # This method initiates a DELETE request to the Ollama API's delete endpoint,
  # utilizing the client instance to send the request and process responses
  # through the provided handler. It handles non-streaming scenarios since
  # delete commands do not support streaming.
  #
  # @param handler [ Ollama::Handler ] the handler object responsible for processing API
  # responses
  #
  # @return [ self ] returns the current instance after initiating the request
  def perform(handler)
    @client.request(method: :delete, path: self.class.path, body: to_json, stream:, handler:)
  end
end

# A command class that represents the embed API endpoint for Ollama.
#
# This class is used to interact with the Ollama API's embed endpoint, which
# generates embeddings for text input using a specified model. It inherits from
# the base command structure and provides the necessary functionality to execute
# embedding requests for generating vector representations of text.
#
# @example Generating embeddings for a single text
#   embed = ollama.embed(model: 'all-minilm', input: 'Why is the sky blue?')
#
# @example Generating embeddings for multiple texts
#   embed = ollama.embed(model: 'all-minilm', input: ['Why is the sky blue?', 'Why is the grass green?'])
class Ollama::Commands::Embed
  include Ollama::DTO

  # The path method returns the API endpoint path for embed requests.
  #
  # This class method provides the specific URL path used to interact with the
  # Ollama API's embed endpoint. It is utilized internally by the command
  # structure to determine the correct API route for generating embeddings.
  #
  # @return [ String ] the API endpoint path '/api/embed' for embed requests
  def self.path
    '/api/embed'
  end

  # The initialize method sets up a new instance with streaming disabled.
  #
  # This method is responsible for initializing a new object instance and
  # configuring it with parameters required for embedding operations. It sets
  # up the model, input text(s), and optional parameters while explicitly
  # disabling streaming since embedding operations are typically non-streaming.
  #
  # @param model [ String ] the name of the model to use for generating embeddings
  # @param input [ String, Array<String> ] the text input(s) to generate embeddings for
  # @param options [ Ollama::Options, nil ] optional configuration parameters for the model
  # @param truncate [ Boolean, nil ] whether to truncate the input if it exceeds context length
  # @param keep_alive [ String, nil ] duration to keep the model loaded in memory
  # @param dimensions [ Integer, nil ] truncates the output embedding to the specified dimension.
  def initialize(model:, input:, options: nil, truncate: nil, keep_alive: nil, dimensions: nil)
    @model, @input, @options, @truncate, @keep_alive, @dimensions =
      model, input, options, truncate, keep_alive, dimensions
    @stream = false
  end

  # The model attribute reader returns the model name associated with the object.
  #
  # @return [ String ] the name of the model used by the command instance
  attr_reader :model

  # The input attribute reader returns the text input(s) associated with the object.
  #
  # @return [ String, Array<String> ] the text input(s) to generate embeddings for
  attr_reader :input

  # The options attribute reader returns the model configuration options associated with the object.
  #
  # @return [ Ollama::Options, nil ] optional configuration parameters for the model
  attr_reader :options

  # The truncate attribute reader returns the truncate setting associated with the object.
  #
  # @return [ Boolean, nil ] whether to truncate the input if it exceeds context length
  attr_reader :truncate

  # The keep_alive attribute reader returns the keep-alive duration associated with the object.
  #
  # @return [ String, nil ] duration to keep the model loaded in memory
  attr_reader :keep_alive

  # The dimensions attribute reader returns the dimensions associated with the
  # object.
  #
  # @return [ Integer, nil ] the dimensions value stored in the instance variable
  attr_reader :dimensions

  # The stream attribute reader returns the streaming behavior setting
  # associated with the object.
  #
  # @return [ FalseClass ] the streaming behavior flag, indicating whether
  #         streaming is enabled for the command execution (always false for embed commands)
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
  # This method initiates a POST request to the Ollama API's embed endpoint,
  # utilizing the client instance to send the request and process responses
  # through the provided handler. It handles non-streaming scenarios since
  # embedding commands do not support streaming.
  #
  # @param handler [ Ollama::Handler ] the handler object responsible for processing API
  # responses
  #
  # @return [ self ] returns the current instance after initiating the request
  def perform(handler)
    @client.request(method: :post, path: self.class.path, body: to_json, stream:, handler:)
  end
end

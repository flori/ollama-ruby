# A command class that represents the embeddings API endpoint for Ollama.
#
# This class is used to interact with the Ollama API's embeddings endpoint, which
# generates embeddings for text input using a specified model. It inherits from
# the base command structure and provides the necessary functionality to execute
# embedding requests for generating vector representations of text.
#
# @example Generating embeddings for a prompt
#   embeddings = ollama.embeddings(model: 'mxbai-embed-large', prompt: 'The sky is blue because of rayleigh scattering')
class Ollama::Commands::Embeddings
  include Ollama::DTO

  # The path method returns the API endpoint path for embeddings requests.
  #
  # This class method provides the specific URL path used to interact with the
  # Ollama API's embeddings endpoint. It is utilized internally by the command
  # structure to determine the correct API route for generating embeddings.
  #
  # @return [ String ] the API endpoint path '/api/embeddings' for embeddings requests
  def self.path
    '/api/embeddings'
  end

  # The initialize method sets up a new instance with streaming disabled.
  #
  # This method is responsible for initializing a new object instance and
  # configuring it with parameters required for embedding operations. It sets
  # up the model, prompt text, and optional parameters while explicitly
  # disabling streaming since embedding operations are typically non-streaming.
  #
  # @param model [ String ] the name of the model to use for generating embeddings
  # @param prompt [ String ] the text prompt to generate embeddings for
  # @param options [ Ollama::Options, nil ] optional configuration parameters for the model
  # @param keep_alive [ String, nil ] duration to keep the model loaded in memory
  def initialize(model:, prompt:, options: nil, keep_alive: nil)
    @model, @prompt, @options, @keep_alive, @stream =
      model, prompt, options, keep_alive, false
  end

  # The model attribute reader returns the model name associated with the object.
  #
  # @return [ String ] the name of the model used by the command instance
  attr_reader :model

  # The prompt attribute reader returns the text prompt associated with the object.
  #
  # @return [ String ] the text prompt to generate embeddings for
  attr_reader :prompt

  # The options attribute reader returns the model configuration options associated with the object.
  #
  # @return [ Ollama::Options, nil ] optional configuration parameters for the model
  attr_reader :options

  # The keep_alive attribute reader returns the keep-alive duration associated with the object.
  #
  # @return [ String, nil ] duration to keep the model loaded in memory
  attr_reader :keep_alive

  # The stream attribute reader returns the streaming behavior setting
  # associated with the object.
  #
  # @return [ FalseClass ] the streaming behavior flag, indicating whether
  #         streaming is enabled for the command execution (always false for embeddings commands)
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
  # This method initiates a POST request to the Ollama API's embeddings endpoint,
  # utilizing the client instance to send the request and process responses
  # through the provided handler. It handles non-streaming scenarios since
  # embeddings commands do not support streaming.
  #
  # @param handler [ Ollama::Handler ] the handler object responsible for processing API
  # responses
  #
  # @return [ self ] returns the current instance after initiating the request
  def perform(handler)
    @client.request(method: :post, path: self.class.path, body: to_json, stream:, handler:)
  end
end

# A command class that represents the chat API endpoint for Ollama.
#
# This class is used to interact with the Ollama API's chat endpoint, which
# generates conversational responses using a specified model. It inherits from
# the base command structure and provides the necessary functionality to execute
# chat requests for interactive conversations with language models.
#
# @example Initiating a chat conversation
#   messages = [
#     Ollama::Message.new(role: 'user', content: 'Hello, how are you?'),
#     Ollama::Message.new(role: 'assistant', content: 'I am doing well, thank you!')
#   ]
#   chat = ollama.chat(model: 'llama3.1', stream: true, messages:)
class Ollama::Commands::Chat
  include Ollama::DTO

  # The path method returns the API endpoint path for chat requests.
  #
  # This class method provides the specific URL path used to interact with the
  # Ollama API's chat endpoint. It is utilized internally by the command
  # structure to determine the correct API route for conversational interactions.
  #
  # @return [ String ] the API endpoint path '/api/chat' for chat requests
  def self.path
    '/api/chat'
  end

  # The initialize method sets up a new instance with streaming behavior.
  #
  # This method is responsible for initializing a new object instance and
  # configuring it with parameters required for chat interactions. It sets up
  # the model, conversation messages, tools, format, options, streaming behavior,
  # keep-alive duration, and thinking mode.
  #
  # @param model [ String ] the name of the model to use for chat responses
  # @param messages [ Array<Ollama::Message>, Hash, nil ] conversation history with roles and content
  # @param tools [ Array<Ollama::Tool>, Hash, nil ] tools available for function calling
  # @param format [ String, nil ] response format (e.g., 'json')
  # @param options [ Ollama::Options, nil ] configuration parameters for the model
  # @param stream [ TrueClass, FalseClass, nil ] whether to enable streaming for the operation
  # @param keep_alive [ String, nil ] duration to keep the model loaded in memory
  # @param think [ Boolean, nil ] whether to enable thinking mode for reasoning
  def initialize(model:, messages:, tools: nil, format: nil, options: nil, stream: nil, keep_alive: nil, think: nil)
    @model, @messages, @tools, @format, @options, @stream, @keep_alive, @think =
      model, as_array_of_hashes(messages), as_array_of_hashes(tools),
      format, options, stream, keep_alive, think
  end

  # The model attribute reader returns the model name associated with the object.
  #
  # @return [ String ] the name of the model to use for chat responses
  attr_reader :model

  # The messages attribute reader returns the conversation history associated with the object.
  #
  # @return [ Array<Ollama::Message>, nil ] conversation history with roles and content
  attr_reader :messages

  # The tools attribute reader returns the available tools associated with the object.
  #
  # @return [ Array<Ollama::Tool>, nil ] tools available for function calling
  attr_reader :tools

  # The format attribute reader returns the response format associated with the object.
  #
  # @return [ String, nil ] response format (e.g., 'json')
  attr_reader :format

  # The options attribute reader returns the model configuration parameters associated with the object.
  #
  # @return [ Ollama::Options, nil ] configuration parameters for the model
  attr_reader :options

  # The stream attribute reader returns the streaming behavior setting
  # associated with the object.
  #
  # @return [ TrueClass, FalseClass, nil ] the streaming behavior flag, indicating whether
  #         streaming is enabled for the command execution (nil by default)
  attr_reader :stream

  # The keep_alive attribute reader returns the keep-alive duration associated with the object.
  #
  # @return [ String, nil ] duration to keep the model loaded in memory
  attr_reader :keep_alive

  # The think attribute reader returns the thinking mode setting associated with the object.
  #
  # @return [ Boolean, nil ] whether thinking mode is enabled for reasoning
  attr_reader :think

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
  # This method initiates a POST request to the Ollama API's chat endpoint,
  # utilizing the client instance to send the request and process responses
  # through the provided handler. It handles both streaming and non-streaming
  # scenarios based on the command's configuration.
  #
  # @param handler [ Ollama::Handler ] the handler object responsible for processing API
  # responses
  #
  # @return [ self ] returns the current instance after initiating the request
  def perform(handler)
    @client.request(method: :post, path: self.class.path, body: to_json, stream:, handler:)
  end
end

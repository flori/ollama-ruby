# A command class that represents the create API endpoint for Ollama.
#
# This class is used to interact with the Ollama API's create endpoint, which
# creates a new model based on a modelfile or existing model. It inherits from
# the base command structure and provides the necessary functionality to execute
# model creation requests.
#
# @example Creating a new model from an existing model
#   create = ollama.create(model: 'llama3.1-wopr', from: 'llama3.1', system: 'You are WOPR from WarGames')
#
# @example Creating a model with files and parameters
#   create = ollama.create(
#     model: 'my-model',
#     from: 'llama3.1',
#     files: { 'modelfile' => 'FROM llama3.1\nPARAMETER temperature 0.7' },
#     parameters: Ollama::Options.new(temperature: 0.7, num_ctx: 8192)
#   )
class Ollama::Commands::Create
  include Ollama::DTO

  # The path method returns the API endpoint path for create requests.
  #
  # This class method provides the specific URL path used to interact with the
  # Ollama API's create endpoint. It is utilized internally by the command
  # structure to determine the correct API route for creating new models.
  #
  # @return [ String ] the API endpoint path '/api/create' for create requests
  def self.path
    '/api/create'
  end

  # The initialize method sets up a new instance with streaming enabled by default.
  #
  # This method is responsible for initializing a new object instance and
  # configuring it with parameters required for model creation. It sets up the
  # model name, source model (if any), files, adapters, template, license,
  # system prompt, parameters, messages, and streaming behavior.
  #
  # @param model [ String ] the name of the new model to be created
  # @param from [ String, nil ] the base model to create from (e.g., 'llama3.1')
  # @param files [ Hash, nil ] file contents for the modelfile and other files
  # @param adapters [ Hash, nil ] adapter files to use for quantization
  # @param template [ String, nil ] the template to use for the model
  # @param license [ String, Array<String>, nil ] the license(s) for the model
  # @param system [ String, nil ] the system prompt to use for the model
  # @param parameters [ Ollama::Options, nil ] configuration parameters for the model
  # @param messages [ Array<Ollama::Message>, nil ] initial conversation messages
  # @param stream [ TrueClass, FalseClass ] whether to enable streaming for the operation, defaults to true
  # @param quantize [ String, nil ] quantization method to use (e.g., 'Q4_0')
  def initialize(model:, from: nil, files: nil, adapters: nil, template: nil, license: nil, system: nil, parameters: nil, messages: nil, stream: true, quantize: nil)
    @model, @from, @files, @adapters, @license, @system, @parameters, @messages, @stream, @quantize =
      model, from, as_hash(files), as_hash(adapters), as_array(license), system,
      as_hash(parameters), as_array_of_hashes(messages), stream, quantize
  end

  # The model attribute reader returns the model name associated with the object.
  #
  # @return [ String ] the name of the new model to be created
  attr_reader :model

  # The from attribute reader returns the base model name associated with the object.
  #
  # @return [ String, nil ] the base model to create from (e.g., 'llama3.1')
  attr_reader :from

  # The files attribute reader returns the file contents associated with the object.
  #
  # @return [ Hash, nil ] file contents for the modelfile and other files
  attr_reader :files

  # The adapters attribute reader returns the adapter files associated with the object.
  #
  # @return [ Hash, nil ] adapter files to use for quantization
  attr_reader :adapters

  # The license attribute reader returns the license(s) associated with the object.
  #
  # @return [ String, Array<String>, nil ] the license(s) for the model
  attr_reader :license

  # The system attribute reader returns the system prompt associated with the object.
  #
  # @return [ String, nil ] the system prompt to use for the model
  attr_reader :system

  # The parameters attribute reader returns the model configuration parameters associated with the object.
  #
  # @return [ Ollama::Options, nil ] configuration parameters for the model
  attr_reader :parameters

  # The messages attribute reader returns the initial conversation messages associated with the object.
  #
  # @return [ Array<Ollama::Message>, nil ] initial conversation messages
  attr_reader :messages

  # The stream attribute reader returns the streaming behavior setting
  # associated with the object.
  #
  # @return [ TrueClass, FalseClass ] the streaming behavior flag, indicating whether
  #         streaming is enabled for the command execution (defaults to true for create commands)
  attr_reader :stream

  # The quantize attribute reader returns the quantization method associated with the object.
  #
  # @return [ String, nil ] quantization method to use (e.g., 'Q4_0')
  attr_reader :quantize

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
  # This method initiates a POST request to the Ollama API's create endpoint,
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

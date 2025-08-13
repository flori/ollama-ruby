# A command class that represents the generate API endpoint for Ollama.
#
# This class is used to interact with the Ollama API's generate endpoint, which
# generates text completions using a specified model. It inherits from the base
# command structure and provides the necessary functionality to execute
# generation requests for text completion tasks.
#
# @example Generating a text completion
#   generate = ollama.generate(model: 'llama3.1', prompt: 'Why is the sky blue?')
#
# @example Generating with streaming enabled
#   generate = ollama.generate(model: 'llama3.1', prompt: 'Why is the sky blue?', stream: true)
class Ollama::Commands::Generate
  include Ollama::DTO

  # The path method returns the API endpoint path for generate requests.
  #
  # This class method provides the specific URL path used to interact with the
  # Ollama API's generate endpoint. It is utilized internally by the command
  # structure to determine the correct API route for text generation operations.
  #
  # @return [ String ] the API endpoint path '/api/generate' for generate requests
  def self.path
    '/api/generate'
  end

  # The initialize method sets up a new instance with default streaming behavior.
  #
  # This method is responsible for initializing a Generate command object with
  # all the necessary parameters for text generation. It handles optional
  # parameters and ensures proper data types (e.g., converting images to arrays).
  #
  # @param model [ String ] the name of the model to use for generation
  # @param prompt [ String ] the text prompt to generate completions for
  # @param suffix [ String, nil ] optional suffix to append to the generated text
  # @param images [ Ollama::Image, Array<Ollama::Image>, nil ] optional image(s) to include in the request
  # @param format [ String, nil ] optional format specification for the response
  # @param options [ Ollama::Options, nil ] optional configuration parameters for the model
  # @param system [ String, nil ] optional system message to set context for generation
  # @param template [ String, nil ] optional template to use for formatting the prompt
  # @param context [ Array<Integer>, nil ] optional context vector for continuation
  # @param stream [ Boolean, nil ] whether to stream responses (default: false)
  # @param raw [ Boolean, nil ] whether to return raw output without formatting
  # @param keep_alive [ String, nil ] duration to keep the model loaded in memory
  # @param think [ Boolean, nil ] whether to enable thinking mode for generation
  def initialize(model:, prompt:, suffix: nil, images: nil, format: nil, options: nil, system: nil, template: nil, context: nil, stream: nil, raw: nil, keep_alive: nil, think: nil)
    @model, @prompt, @suffix, @images, @format, @options, @system, @template, @context, @stream, @raw, @keep_alive, @think =
      model, prompt, suffix, (Array(images) if images), format, options, system, template, context, stream, raw, keep_alive, think
  end

  # The model attribute reader returns the model name associated with the generate command.
  #
  # @return [ String ] the name of the model used for generation
  attr_reader :model

  # The prompt attribute reader returns the text prompt used for generation.
  #
  # @return [ String ] the text prompt to generate completions for
  attr_reader :prompt

  # The suffix attribute reader returns any suffix that was appended to the generated text.
  #
  # @return [ String, nil ] optional suffix to append to the generated text
  attr_reader :suffix

  # The images attribute reader returns image objects associated with the generate command.
  #
  # @return [ Array<Ollama::Image>, nil ] array of image objects, or nil if none provided
  attr_reader :images

  # The format attribute reader returns the format specification for the response.
  #
  # @return [ String, nil ] optional format specification for the response
  attr_reader :format

  # The options attribute reader returns configuration parameters for the model.
  #
  # @return [ Ollama::Options, nil ] optional configuration parameters for the model
  attr_reader :options

  # The system attribute reader returns the system message that sets context for generation.
  #
  # @return [ String, nil ] optional system message to set context for generation
  attr_reader :system

  # The template attribute reader returns the template used for formatting the prompt.
  #
  # @return [ String, nil ] optional template to use for formatting the prompt
  attr_reader :template

  # The context attribute reader returns the context vector for continuation.
  #
  # @return [ Array<Integer>, nil ] optional context vector for continuation
  attr_reader :context

  # The stream attribute reader returns whether responses will be streamed.
  #
  # @return [ Boolean, nil ] whether to stream responses (default: false)
  attr_reader :stream

  # The raw attribute reader returns whether raw output without formatting should be returned.
  #
  # @return [ Boolean, nil ] whether to return raw output without formatting
  attr_reader :raw

  # The keep_alive attribute reader returns the duration to keep the model loaded in memory.
  #
  # @return [ String, nil ] duration to keep the model loaded in memory
  attr_reader :keep_alive

  # The think attribute reader returns whether thinking mode is enabled for generation.
  #
  # @return [ Boolean, nil ] whether to enable thinking mode for generation
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

  # The perform method executes the generate command using the specified handler.
  #
  # This method sends a POST request to the Ollama API's generate endpoint with
  # the command parameters serialized as JSON. It delegates to the client's request
  # method for actual HTTP communication.
  #
  # @param handler [ Ollama::Handler ] the handler to process responses from the API
  # @return [ void ]
  def perform(handler)
    @client.request(method: :post, path: self.class.path, body: to_json, stream:, handler:)
  end
end

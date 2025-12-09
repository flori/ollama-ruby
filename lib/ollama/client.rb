# A class that serves as the main entry point for interacting with the Ollama API.
#
# The Client class provides methods to communicate with an Ollama server, handling
# various API endpoints such as chat, generate, create, and model management commands.
# It manages configuration settings like base URL, timeouts, and output streams,
# and supports different response handlers for processing API results.
#
# @example Initializing a client with a base URL
#   client = Ollama::Client.new(base_url: 'http://localhost:11434')
#
# @example Configuring a client using a configuration object
#   config = Ollama::Client::Config[base_url: 'http://localhost:11434']
#   client = Ollama::Client.configure_with(config)
class Ollama::Client
end
require 'ollama/client/doc'
require 'ollama/client/command'
require 'ollama/client/configuration/config'

class Ollama::Client
  include Tins::Annotate
  include Ollama::Handlers
  include Ollama::Client::Configuration
  include Ollama::Client::Command

  annotate :doc

  # The initialize method sets up a new client instance with the specified configuration parameters.
  #
  # This method is responsible for initializing a new Ollama::Client instance by processing
  # various configuration options including the base URL, output stream, timeouts, and debug settings.
  # It handles default values for the base URL by falling back to an environment variable,
  # validates that the base URL is a valid HTTP or HTTPS URI, and extracts SSL verification
  # settings from query parameters. The method also sets up instance variables for all
  # configuration options, making them available for use in subsequent client operations.
  #
  # @param base_url [ String, nil ] the base URL of the Ollama API endpoint, defaults to nil
  # @param output [ IO ] the output stream to be used for handling responses, defaults to $stdout
  # @param connect_timeout [ Integer, nil ] the connection timeout value in seconds, defaults to nil
  # @param read_timeout [ Integer, nil ] the read timeout value in seconds, defaults to nil
  # @param write_timeout [ Integer, nil ] the write timeout value in seconds, defaults to nil
  # @param debug [ Boolean, nil ] the debug flag indicating whether debug output is enabled, defaults to nil
  # @param user_agent [ String, nil ] the user agent string to be used for API requests, defaults to nil
  def initialize(base_url: nil, output: $stdout, connect_timeout: nil, read_timeout: nil, write_timeout: nil, debug: nil, user_agent: nil)
    base_url.nil? and base_url = ENV.fetch('OLLAMA_URL') do
      raise ArgumentError,
        'missing :base_url parameter or OLLAMA_URL environment variable'
    end
    base_url.is_a? URI or base_url = URI.parse(base_url)
    base_url.is_a?(URI::HTTP) || base_url.is_a?(URI::HTTPS) or
      raise ArgumentError, "require #{base_url.inspect} to be http/https-URI"
    @ssl_verify_peer = base_url.query.to_s.split(?&).inject({}) { |h, l|
      h.merge Hash[*l.split(?=)]
    }['ssl_verify_peer'] != 'false'
    @base_url, @output, @connect_timeout, @read_timeout, @write_timeout, @debug, @user_agent =
      base_url, output, connect_timeout, read_timeout, write_timeout, debug, user_agent
  end

  # The output attribute accessor allows reading and setting the output stream
  # used for handling responses and messages.
  #
  # @attr [ IO ] the output stream, typically $stdout, to which responses and
  #         messages are written
  attr_accessor :output

  # The base_url attribute reader returns the base URL used for making requests to the Ollama API.
  #
  # @return [ URI ] the base URL configured for API requests
  attr_reader :base_url

  # The ssl_verify_peer? method checks whether SSL peer verification is enabled.
  #
  # This method returns a boolean value indicating if the client should verify
  # the SSL certificate of the Ollama server during communication. It converts
  # the internal SSL verification flag to a boolean value for easy checking.
  #
  # @return [ TrueClass, FalseClass ] true if SSL peer verification is enabled,
  #         false otherwise
  def ssl_verify_peer?
    !!@ssl_verify_peer
  end

  # Defines a command method with its associated command class and handlers.
  #
  # This is an example of Ruby's metaprogramming capabilities where we dynamically
  # create methods that delegate to specific command classes. The client supports
  # many commands including chat, generate, tags, show, create, copy, delete,
  # pull, push, embed, embeddings, ps, and version.
  #
  # @example Generated command method
  #   client.chat(model: 'llama3.1', messages: [{role: 'user', content: 'Hello'}])
  command(:chat, default_handler: Single, stream_handler: Collector)

  command(:generate, default_handler: Single, stream_handler: Collector)

  command(:tags, default_handler: Single)

  command(:show, default_handler: Single)

  command(:create, default_handler: Single, stream_handler: Progress)

  command(:copy, default_handler: Single)

  command(:delete, default_handler: Single)

  command(:pull, default_handler: Single, stream_handler: Progress)

  command(:push, default_handler: Single, stream_handler: Progress)

  command(:embed, default_handler: Single)

  command(:embeddings, default_handler: Single)

  command(:ps, default_handler: Single)

  command(:version, default_handler: Single)

  # The commands method retrieves and sorts the documented commands available
  # in the client.
  #
  # This method extracts all command annotations from the class, sorts them by
  # their names, and returns an array containing only the command names in
  # alphabetical order.
  #
  # @return [ Array<String> ] an array of command names sorted alphabetically
  def commands
    doc_annotations.sort_by(&:first).transpose.last
  end

  doc Doc.new(:help)
  # The help method displays a list of available commands to the output stream.
  #
  # This method retrieves the sorted list of documented commands from the client
  # and outputs them as a comma-separated string to the configured output stream.
  # It is typically used to provide users with information about which commands
  # are available for execution through the client interface.
  def help
    @output.puts "Commands: %s" % commands.join(?,)
  end

  # The request method sends an HTTP request to the Ollama API and processes
  # responses through a handler.
  #
  # This method constructs an HTTP request to the specified API endpoint,
  # handling both streaming and non-streaming responses. It manages different
  # HTTP status codes, including success (200), not found (404), and other
  # error cases. The method also includes comprehensive error handling for
  # network-related issues such as socket errors and timeouts.
  #
  # @param method [ Symbol ] the HTTP method to use for the request (:get, :post, :delete)
  # @param path [ String ] the API endpoint path to request
  # @param handler [ Ollama::Handler ] the handler object responsible for processing API responses
  # @param body [ String, nil ] the request body content, if applicable
  # @param stream [ TrueClass, FalseClass, nil ] whether to enable streaming for the operation
  #
  # @return [ Ollama::Client ] returns the client instance itself after initiating the request
  def request(method:, path:, handler:, body: nil, stream: nil)
    url = @base_url + path
    responses = Enumerator.new do |yielder|
      if stream
        response_block = -> chunk, remaining_bytes, total_bytes do
          response_line = parse_json(chunk)
          response_line and yielder.yield response_line
        end
        response = excon(url).send(method, headers:, body:, response_block:)
      else
        response = excon(url).send(method, headers:, body:)
      end

      case response.status
      when 200
        response.body.each_line do |l|
          response_line = parse_json(l)
          response_line and yielder.yield response_line
        end
      when 400
        raise Ollama::Errors::BadRequestError, "#{response.status} #{response.body.inspect}"
      when 404
        raise Ollama::Errors::NotFoundError, "#{response.status} #{response.body.inspect}"
      else
        raise Ollama::Errors::Error, "#{response.status} #{response.body.inspect}"
      end
    end
    responses.each { |response| handler.call(response) }
    self
  rescue Excon::Errors::SocketError => e
    raise Ollama::Errors::SocketError, "Caught #{e.class} #{e.message.inspect} for #{url.to_s.inspect}"
  rescue Excon::Errors::Timeout => e
    raise Ollama::Errors::TimeoutError, "Caught #{e.class} #{e.message.inspect} for #{url.to_s.inspect}"
  rescue Excon::Error => e
    raise Ollama::Errors::Error, "Caught #{e.class} #{e.message.inspect} for #{url.to_s.inspect}"
  end

  # The inspect method returns a string representation of the client instance.
  #
  # This method provides a human-readable description of the client object,
  # including its class name and the base URL it is configured to use.
  #
  # @return [ String ] a string representation in the format "#<Ollama::Client@http://localhost:11434>"
  def inspect
    "#<#{self.class}@#{@base_url}>"
  end

  alias to_s inspect

  private

  # The headers method constructs and returns a hash of HTTP headers.
  #
  # This method generates a set of standard HTTP headers required for making
  # requests to the Ollama API, including the User-Agent and Content-Type. It
  # uses the instance's configured user agent or falls back to the class-level
  # user agent if none is set.
  #
  # @return [ Hash ] a hash containing the HTTP headers with keys 'User-Agent' and 'Content-Type'
  def headers
    {
      'User-Agent'   => @user_agent || self.class.user_agent,
      'Content-Type' => 'application/json; charset=utf-8',
    }
  end

  # The user_agent method generates a formatted user agent string for API requests.
  #
  # This method creates a user agent identifier that combines the class name
  # with the library version, which is used to identify the client making
  # requests to the Ollama API.
  #
  # @return [ String ] a formatted user agent string in the format "Ollama::Client/1.2.3"
  def self.user_agent
    '%s/%s' % [ self, Ollama::VERSION ]
  end

  # The excon method creates and returns a new Excon client instance configured
  # with the receiver's timeout and debugging settings.
  #
  # This method constructs an Excon client object using the provided URL and
  # configures it with connection, read, and write timeouts, SSL verification
  # settings, and debug mode based on the instance variables of the receiver.
  # It compacts the parameters hash to remove any nil values before passing
  # them to Excon.new.
  #
  # @param url [ String ] the URL to be used for the Excon client
  #
  # @return [ Excon ] a new Excon client instance configured with the specified parameters
  def excon(url)
    params = {
      connect_timeout: @connect_timeout,
      read_timeout:    @read_timeout,
      write_timeout:   @write_timeout,
      ssl_verify_peer: @ssl_verify_peer,
      debug:           @debug,
    }.compact
    Excon.new(url, params)
  end

  # The parse_json method attempts to parse a JSON string into a structured
  # object.
  #
  # This method takes a string containing JSON data and converts it into a Ruby
  # object using the JSON.parse method. It specifies Ollama::Response as the
  # object class to ensure that the parsed data is wrapped in the appropriate
  # response structure.
  #
  # @param string [ String ] the JSON string to be parsed
  #
  # @return [ Ollama::Response, nil ] the parsed JSON object or nil if parsing fails
  def parse_json(string)
    JSON.parse(string, object_class: Ollama::Response)
  rescue JSON::ParserError => e
    warn "Caught #{e.class}: #{e}"
    return
  end
end

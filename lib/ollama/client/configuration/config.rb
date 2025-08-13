require 'ollama/json_loader'

# A module that provides configuration management capabilities for the Ollama
# client.
#
# This module extends the client with functionality to manage and apply
# configuration settings such as base URL, timeouts, and output streams. It
# allows for flexible initialization of client instances using either direct
# parameters or pre-defined configuration objects, supporting both programmatic
# and file-based configuration approaches.
#
# @example Configuring a client with a hash of attributes
#   config = Ollama::Client::Config[base_url: 'http://localhost:11434']
#   client = Ollama::Client.configure_with(config)
#
# @example Loading configuration from a JSON file
#   config = Ollama::Client::Config.load_from_json('path/to/config.json')
#   client = Ollama::Client.configure_with(config)
module Ollama::Client::Configuration


  # A class that encapsulates configuration settings for Ollama clients.
  #
  # This class provides a structured way to define and manage various
  # configuration options that can be used when initializing Ollama client
  # instances. It includes properties for setting the base URL, output stream,
  # and timeout values.
  #
  # @example Creating a configuration object
  #   config = Ollama::Client::Config[
  #     base_url: 'http://localhost:11434',
  #     output: $stdout,
  #     connect_timeout: 15,
  #     read_timeout: 300
  #   ]
  #
  # @example Loading configuration from a JSON file
  #   config = Ollama::Client::Config.load_from_json('path/to/config.json')
  class Config
    extend Ollama::JSONLoader

    # The initialize method sets up a new configuration instance with the
    # specified attributes.
    #
    # This method is responsible for initializing a new
    # Ollama::Client::Configuration::Config instance by processing various
    # configuration options. It iterates through the provided attributes and
    # assigns them to corresponding setter methods, then ensures that the
    # output stream is set to $stdout if no output was specified.
    #
    # @param attributes [ Hash ] a hash containing the configuration attributes to be set
    #
    # @return [ Ollama::Client::Configuration::Config ] returns the initialized configuration instance
    def initialize(**attributes)
      attributes.each { |k, v| send("#{k}=", v) }
      self.output ||= $stdout
    end

    # The [] method creates a new instance of the class using a hash of
    # attributes.
    #
    # This class method provides a convenient way to instantiate an object by
    # passing a hash containing the desired attribute values. It converts the
    # hash keys to symbols and forwards them as keyword arguments to the
    # constructor.
    #
    # @param value [ Hash ] a hash containing the attribute names and their values
    #
    # @return [ self ] a new instance of the class initialized with the provided
    # attributes
    def self.[](value)
      new(**value.to_h)
    end

    # The base_url attribute accessor allows reading and setting the base URL
    # of the Ollama API endpoint.
    #
    # @attr [ URI ] the new base URL to be set for API requests
    attr_accessor :base_url

    # The output attribute accessor allows reading and setting the output stream
    # used for handling responses and messages.
    #
    # @attr [ IO ] the new output stream to be set for response handling
    attr_accessor :output

    # The connect_timeout attribute accessor allows reading and setting the
    # connection timeout value.
    #
    # @attr [ Integer, nil ] the new connection timeout value to be set
    attr_accessor :connect_timeout

    # The read_timeout attribute accessor allows reading and setting the read
    # timeout value.
    #
    # @attr [ Integer, nil ] the new read timeout value to be set
    attr_accessor :read_timeout

    # The write_timeout attribute accessor allows reading and setting the write
    # timeout value.
    #
    # @attr [ Integer, nil ] the new write timeout value to be set
    attr_accessor :write_timeout

    # The debug attribute accessor allows reading and setting the debug flag.
    #
    # @attr [ Boolean, nil ] the new debug flag value to be set
    attr_accessor :debug

    # The user_agent attribute accessor allows reading and setting the user
    # agent string used for making requests to the Ollama API.
    #
    # @attr [ String, nil ] the new user agent string to be set for API requests
    attr_accessor :user_agent
  end

  extend Tins::Concern

  class_methods do
    # The configure_with method initializes a new client instance using the
    # provided configuration object.

    # This method takes a configuration object and uses its attributes to set
    # up a new Ollama::Client instance. It extracts individual configuration
    # parameters from the input object and passes them to the client's
    # constructor, allowing for flexible initialization based on pre-defined
    # settings.

    # @param config [ Ollama::Client::Configuration::Config ] the configuration
    # object containing client settings
    #
    # @return [ Ollama::Client ] a new client instance configured with the
    # provided settings
    def configure_with(config)
      new(
        base_url:        config.base_url,
        output:          config.output,
        connect_timeout: config.connect_timeout,
        read_timeout:    config.read_timeout,
        write_timeout:   config.write_timeout,
        debug:           config.debug,
        user_agent:      config.user_agent
      )
    end
  end
end

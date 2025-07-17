require 'ollama/json_loader'

module Ollama::Client::Configuration
  class Config
    extend Ollama::JSONLoader

    def initialize(**attributes)
      attributes.each { |k, v| send("#{k}=", v) }
      self.output ||= $stdout
    end

    def self.[](value)
      new(**value.to_h)
    end

    attr_accessor :base_url, :output, :connect_timeout, :read_timeout,
      :write_timeout, :debug, :user_agent
  end

  extend Tins::Concern

  module ClassMethods
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

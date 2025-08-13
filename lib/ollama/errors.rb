module Ollama

  # A module that groups together various error classes used by the Ollama client.
  #
  # This module serves as a namespace for custom exception types that are raised
  # when errors occur during interactions with the Ollama API, providing more
  # specific information about the nature of the problem.
  module Errors
    # The base error class for Ollama-related exceptions.
    #
    # This class serves as the parent class for all custom exceptions raised by the Ollama library.
    # It provides a common foundation for error handling within the gem, allowing developers to
    # rescue specific Ollama errors or the general error type when interacting with the Ollama API.
    class Error < StandardError
    end

    # Ollama error class for handling cases where a requested resource is not
    # found.
    #
    # This exception is raised when the Ollama API returns a 404 status code,
    # indicating that the requested model or resource could not be located.
    #
    # @example Handling a not found error
    #   begin
    #     ollama.show(model: 'nonexistent-model')
    #   rescue Ollama::Errors::NotFoundError
    #     puts "Model was not found"
    #   end
    class NotFoundError < Error
    end

    # Ollama error class for handling timeout errors when communicating with
    # the Ollama API.
    #
    # This exception is raised when a request to the Ollama API times out
    # during connection, reading, or writing operations. It inherits from
    # Ollama::Errors::Error and provides specific handling for timeout-related
    # issues.
    #
    # @example Handling a timeout error
    #   begin
    #     ollama.generate(model: 'llama3.1', prompt: 'Hello World')
    #   rescue Ollama::Errors::TimeoutError
    #     puts "Request timed out, consider increasing timeouts"
    #   end
    class TimeoutError < Error
    end

    # Ollama error class for handling socket errors when communicating with the Ollama API.
    #
    # This exception is raised when a socket-level error occurs while
    # attempting to connect to or communicate with the Ollama API.
    # It inherits from Ollama::Errors::Error and provides specific handling for
    # network-related issues that prevent successful API communication.
    #
    # @example Handling a socket error
    #   begin
    #     ollama.generate(model: 'llama3.1', prompt: 'Hello World')
    #   rescue Ollama::Errors::SocketError
    #     puts "Network connection failed"
    #   end
    class SocketError < Error
    end
  end
end

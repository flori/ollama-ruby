# Represents a tool definition used in interactions with the Ollama API.
# This class encapsulates the structure required for defining tools that can be
# passed to models to enable function calling capabilities. It includes the type
# of tool and the associated function definition, which specifies the tool's name,
# description, parameters, and required fields.
#
# @example Creating a tool with a function definition
#   tool = Ollama::Tool.new(
#     type: 'function',
#     function: Ollama::Tool::Function.new(
#       name: 'get_current_weather',
#       description: 'Get the current weather for a location',
#       parameters: Ollama::Tool::Function::Parameters.new(
#         type: 'object',
#         properties: { location: property },
#         required: %w[location]
#       )
#     )
#   )
class Ollama::Tool
  include Ollama::DTO

  # The type attribute reader returns the type associated with the tool.
  #
  # @return [ String ] the type of tool, typically 'function' for function
  # calling capabilities
  attr_reader :type

  # The function attribute reader returns the function definition associated
  # with the tool.
  #
  # @return [ Hash ] the function definition as a hash, containing details such
  # as the function's name, description, parameters, and required fields
  attr_reader :function

  # The initialize method sets up a new Tool instance with the specified type
  # and function.
  #
  # @param type [ String ] the type of tool being created
  # @param function [ Ollama::Tool::Function ] the function definition
  # associated with the tool
  def initialize(type:, function:)
    @type, @function = type, function.to_hash
  end
end

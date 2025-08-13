# A class that represents a function definition for tool usage in Ollama API
# interactions.
#
# This class encapsulates the structure required for defining functions that
# can be passed to models to enable function calling capabilities. It includes
# the function's name, description, parameters specification, and list of
# required parameters.
#
# @example Creating a function definition for a tool
#   function = Ollama::Tool::Function.new(
#     name: 'get_current_weather',
#     description: 'Get the current weather for a location',
#     parameters: parameters,
#     required: %w[location]
#   )
class Ollama::Tool::Function
  include Ollama::DTO

  # The name attribute reader returns the name associated with the object.
  #
  # @return [ String ] the name value stored in the instance variable
  attr_reader :name

  # The description attribute reader returns the description associated with
  # the object.
  #
  # @return [ String ] the description value stored in the instance variable
  attr_reader :description

  # The parameters attribute reader returns the parameters associated with the
  # object.
  #
  # @return [ Hash, nil ] the parameters hash, or nil if not set
  attr_reader :parameters

  # The required attribute reader returns the required parameter values
  # associated with the object.
  #
  # @return [ Array<String>, nil ] an array of required parameter names, or nil if not set
  attr_reader :required

  # The initialize method sets up a new Tool::Function instance with the
  # specified attributes.
  #
  # @param name [ String ] the name of the function
  # @param description [ String ] a brief description of what the function does
  # @param parameters [ Hash, nil ] optional parameters specification for the function
  # @param required [ Array<String>, nil ] optional array of required parameter names
  def initialize(name:, description:, parameters: nil, required: nil)
    @name, @description, @parameters, @required =
      name, description, (Hash(parameters) if parameters),
      (Array(required) if required)
  end
end

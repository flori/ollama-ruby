# A class that represents a single property within the parameters specification
# for a tool function.
#
# This class encapsulates the definition of an individual parameter, including
# its data type, descriptive text, and optional enumeration values that define
# valid inputs.
#
# @example Creating a property with type and description
#   property = Ollama::Tool::Function::Parameters::Property.new(
#     type: 'string',
#     description: 'The location to get weather for'
#   )
#
# @example Creating a property with an enumeration of valid values
#   property = Ollama::Tool::Function::Parameters::Property.new(
#     type: 'string',
#     description: 'Temperature unit',
#     enum: %w[celsius fahrenheit]
#   )
class Ollama::Tool::Function::Parameters::Property
  include Ollama::DTO

  # The type attribute reader returns the type associated with the object.
  #
  # @return [ String ] the type value stored in the instance variable
  attr_reader :type

  # The description attribute reader returns the description associated with
  # the object.
  #
  # @return [ String ] the description value stored in the instance variable
  attr_reader :description

  # The enum attribute reader returns the enumeration values associated with the object.
  #
  # @return [ Array<String>, nil ] an array of valid string values that the
  # property can take, or nil if not set
  attr_reader :enum

  # The initialize method sets up a new Property instance with the specified
  # attributes.
  #
  # @param type [ String ] the data type of the property
  # @param description [ String ] a detailed explanation of what the property represents
  # @param enum [ Array<String>, nil ] an optional array of valid values that the property can take
  def initialize(type:, description:, enum: nil)
    @type, @description, @enum = type, description, Array(enum)
  end
end

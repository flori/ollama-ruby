# A class that represents the parameters specification for a tool function in
# Ollama API interactions.
#
# This class encapsulates the structure required for defining the parameters
# that a function tool accepts. It includes the type of parameter object, the
# properties of each parameter, and which parameters are required.
#
# @example Creating a parameters specification for a tool function
#   property = Ollama::Tool::Function::Parameters::Property.new(
#     type: 'string',
#     description: 'The location to get weather for'
#   )
#   parameters = Ollama::Tool::Function::Parameters.new(
#     type: 'object',
#     properties: { location: property },
#     required: %w[location]
#   )
class Ollama::Tool::Function::Parameters
  include Ollama::DTO

  # The type attribute reader returns the type associated with the object.
  #
  # @return [ String ] the type value stored in the instance variable
  attr_reader :type

  # The properties attribute reader returns the properties associated with the
  # object.
  #
  # @return [ Hash ] the properties hash, or nil if not set
  attr_reader :properties

  # The required attribute reader returns the required parameter values
  # associated with the object.
  #
  # @return [ Array<String>, nil ] an array of required parameter names, or nil
  # if not set
  attr_reader :required

  # The initialize method sets up a new Parameters instance with the specified
  # attributes.
  #
  # @param type [ String ] the type of parameter object
  # @param properties [ Hash ] the properties of each parameter
  # @param required [ Array<String> ] the names of required parameters
  def initialize(type:, properties:, required:)
    @type, @properties, @required =
      type, Hash(properties).transform_values(&:to_hash), Array(required)
  end
end

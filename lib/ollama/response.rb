# A subclass of JSON::GenericObject that represents responses from the Ollama API.
#
# This class serves as a specialized response object that extends
# JSON::GenericObject to provide structured access to API response data. It
# maintains the ability to convert to JSON format while preserving the response
# data in a hash-like structure.
#
# @example Accessing response data
#   response = Ollama::Response.new(key: 'value')
#   response[:key] # => 'value'
class Ollama::Response < JSON::GenericObject
  # The as_json method converts the object's attributes into a JSON-compatible hash.
  #
  # This method gathers all defined attributes of the object and constructs a
  # hash representation, excluding any nil values or empty collections.
  #
  # @note This removes "json_class" attribute from hash for responses.
  # @return [ Hash ] a hash containing the object's non-nil and non-empty attributes
  def as_json(*)
    to_hash
  end
end

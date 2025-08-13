# A module that provides a foundation for data transfer objects (DTOs) within
# the Ollama library.
#
# The DTO module includes common functionality for converting objects to and
# from JSON, handling attribute management, and providing utility methods for
# processing arrays and hashes. It serves as a base class for various command
# and data structures used in communicating with the Ollama API.
#
# @example Using DTO functionality in a command class
#   class MyCommand
#     include Ollama::DTO
#     attr_reader :name, :value
#     def initialize(name:, value:)
#       @name, @value = name, value
#     end
#   end
module Ollama::DTO
  extend Tins::Concern

  included do
    self.attributes = Set.new
  end

  class_methods do
    # The attributes accessor reads and writes the attributes instance
    # variable.
    #
    # @return [ Set ] the set of attributes stored in the instance variable
    attr_accessor :attributes

    # The from_hash method creates a new instance of the class by converting a
    # hash into keyword arguments.
    #
    # This method is typically used to instantiate objects from JSON data or
    # other hash-based sources, transforming the hash keys to symbols and
    # passing them as keyword arguments to the constructor.
    #
    # @param hash [ Hash ] a hash containing the attributes for the new instance
    #
    # @return [ self ] a new instance of the class initialized with the hash data
    def from_hash(hash)
      new(**hash.transform_keys(&:to_sym))
    end

    # The attr_reader method extends the functionality of the standard
    # attr_reader by also registering the declared attributes in the class's
    # attributes set.
    #
    # @param names [ Array<Symbol> ] one or more attribute names to be declared
    # as readable and registered
    def attr_reader(*names)
      super
      attributes.merge(names.map(&:to_sym))
    end
  end

  # The as_array_of_hashes method converts an object into an array of hashes.
  #
  # If the object responds to to_hash, it wraps the result in an array.
  # If the object responds to to_ary, it maps each element to a hash and
  # returns the resulting array.
  #
  # @param obj [ Object ] the object to be converted
  #
  # @return [ Array<Hash>, nil ] an array of hashes if the conversion was
  # possible, or nil otherwise
  def as_array_of_hashes(obj)
    if obj.respond_to?(:to_hash)
      [ obj.to_hash ]
    elsif obj.respond_to?(:to_ary)
      obj.to_ary.map(&:to_hash)
    end
  end

  # The as_hash method converts an object to a hash representation.
  #
  # If the object responds to to_hash, it returns the result of that method call.
  # If the object does not respond to to_hash, it returns nil.
  #
  # @param obj [ Object ] the object to be converted to a hash
  #
  # @return [ Hash, nil ] the hash representation of the object or nil if the
  # object does not respond to to_hash
  def as_hash(obj)
    obj&.to_hash
  end

  # The as_array method converts an object into an array representation.
  #
  # If the object is nil, it returns nil.
  # If the object responds to to_ary, it calls to_ary and returns the result.
  # Otherwise, it wraps the object in an array and returns it.
  #
  # @param obj [ Object ] the object to be converted to an array
  #
  # @return [ Array, nil ] an array containing the object or its elements, or
  # nil if the input is nil
  def as_array(obj)
    if obj.nil?
      obj
    elsif obj.respond_to?(:to_ary)
      obj.to_ary
    else
      [ obj ]
    end
  end

  # The as_json method converts the object's attributes into a JSON-compatible
  # hash.
  #
  # This method gathers all defined attributes of the object and constructs a
  # hash representation, excluding any nil values or empty collections.
  #
  # @return [ Hash ] a hash containing the object's non-nil and non-empty attributes
  def as_json(*)
    self.class.attributes.each_with_object({}) { |a, h| h[a] = send(a) }.
      reject { _2.nil? || _2.ask_and_send(:size) == 0 }
  end

  # The == method compares two objects for equality based on their JSON representation.
  #
  # This method checks if the JSON representation of the current object is
  # equal to the JSON representation of another object.
  #
  # @param other [ Object ] the object to compare against
  #
  # @return [ TrueClass, FalseClass ] true if both objects have identical JSON
  # representations, false otherwise
  def ==(other)
    as_json == other.as_json
  end

  alias to_hash as_json

  # The empty? method checks whether the object has any attributes defined.
  #
  # This method determines if the object contains no attributes by checking
  # if its hash representation is empty. It is typically used to verify
  # if an object, such as a DTO, has been initialized with any values.
  #
  # @return [ TrueClass, FalseClass ] true if the object has no attributes,
  # false otherwise
  def empty?
    to_hash.empty?
  end

  # The to_json method converts the object's JSON representation into a JSON
  # string format.
  #
  # This method utilizes the object's existing as_json representation and
  # applies the standard JSON serialization to produce a formatted JSON string
  # output.
  #
  # @return [ String ] a JSON string representation of the object
  def to_json(*)
    as_json.to_json(*)
  end
end

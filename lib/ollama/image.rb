require 'base64'

# Ollama::Image
#
# Represents an image object that can be used in messages sent to the Ollama API.
# The Image class provides methods to create image objects from various sources
# including base64 encoded strings, file paths, IO objects, and raw string data.
#
# @example Creating an image from a file path
#   image = Ollama::Image.for_filename('path/to/image.jpg')
#
# @example Creating an image from a base64 string
#   image = Ollama::Image.for_base64('base64encodedstring', path: 'image.jpg')
#
# @example Creating an image from a string
#   image = Ollama::Image.for_string('raw image data')
#
# @example Creating an image from an IO object
#   File.open('path/to/image.jpg', 'rb') do |io|
#     image = Ollama::Image.for_io(io, path: 'image.jpg')
#   end
class Ollama::Image
  # Initializes a new Image object with the provided data.
  #
  # @param data [ String ] the image data to store in the object
  def initialize(data)
    @data = data
  end

  # The path attribute stores the file path associated with the image object.
  #
  # @return [ String, nil ] the path to the image file, or nil if not set
  attr_accessor :path

  # The data attribute reader returns the image data stored in the object.
  #
  # @return [ String ] the raw image data contained within the image object
  attr_reader :data

  class << self
    # Creates a new Image object from base64 encoded data.
    #
    # @param data [ String ] the base64 encoded image data
    # @param path [ String, nil ] the optional file path associated with the image
    #
    # @return [ Ollama::Image ] a new Image instance initialized with the
    # provided data and path
    def for_base64(data, path: nil)
      obj = new(data)
      obj.path = path
      obj
    end

    # Creates a new Image object from a string by encoding it to base64.
    #
    # @param string [ String ] the raw string data to be converted into an image
    # @param path [ String, nil ] the optional file path associated with the image
    #
    # @return [ Ollama::Image ] a new Image instance initialized with the
    # encoded string data and optional path
    def for_string(string, path: nil)
      for_base64(Base64.strict_encode64(string), path:)
    end

    # Creates a new Image object from an IO object by reading its contents and
    # optionally setting a path.
    #
    # @param io [ IO ] the IO object to read image data from
    # @param path [ String, nil ] the optional file path associated with the image
    #
    # @return [ Ollama::Image ] a new Image instance initialized with the IO
    # object's data and optional path
    def for_io(io, path: nil)
      path ||= io.path
      for_string(io.read, path:)
    end

    # Creates a new Image object from a file path by opening the file in binary
    # mode and passing it to the for_io method.
    #
    # @param path [ String ] the file system path to the image file
    #
    # @return [ Ollama::Image ] a new Image instance initialized with the
    # contents of the file at the specified path
    def for_filename(path)
      File.open(path, 'rb') { |io| for_io(io, path:) }
    end

    private :new
  end

  # The == method compares two Image objects for equality based on their data
  # contents.
  #
  # @param other [ Ollama::Image ] the other Image object to compare against
  #
  # @return [ TrueClass, FalseClass ] true if both Image objects have identical
  # data, false otherwise
  def ==(other)
    @data == other.data
  end

  # The to_s method returns the raw image data stored in the Image object.
  #
  # @return [ String ] the raw image data contained within the image object
  def to_s
    @data
  end

  # Returns the base64-encoded string representation of the image data.
  # When this object is serialized to JSON, it will produce a quoted base64
  # string as required by the Ollama API.
  #
  # @param _args [Array] ignored arguments (for compatibility with JSON serialization)
  # @return [String] the base64-encoded image data
  def as_json(*_args)
    to_s
  end
end

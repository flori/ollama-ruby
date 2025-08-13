# Ollama::Message
#
# Represents a message object used in communication with the Ollama API.
# This class encapsulates the essential components of a message, including
# the role of the sender, the content of the message, optional thinking
# content, associated images, and tool calls.
#
# @example Creating a basic message
#   message = Ollama::Message.new(
#     role: 'user',
#     content: 'Hello, world!'
#   )
#
# @example Creating a message with additional attributes
#   image = Ollama::Image.for_filename('path/to/image.jpg')
#   message = Ollama::Message.new(
#     role: 'user',
#     content: 'Look at this image',
#     images: [image]
#   )
class Ollama::Message
  include Ollama::DTO

  # The role attribute reader returns the role associated with the message.
  #
  # @return [ String ] the role of the message sender, such as 'user' or 'assistant'
  attr_reader :role

  # The content attribute reader returns the textual content of the message.
  #
  # @return [ String ] the content of the message
  attr_reader :content

  # The thinking attribute reader returns the thinking content associated with the message.
  #
  # @return [ String, nil ] the thinking content of the message, or nil if not set
  attr_reader :thinking

  # The images attribute reader returns the image objects associated with the message.
  #
  # @return [ Array<Ollama::Image>, nil ] an array of image objects, or nil if no images are associated with the message
  attr_reader :images

  # The initialize method sets up a new Message instance with the specified attributes.
  #
  # @param role [ String ] the role of the message sender, such as 'user' or 'assistant'
  # @param content [ String ] the textual content of the message
  # @param thinking [ String, nil ] optional thinking content for the message
  # @param images [ Ollama::Image, Array<Ollama::Image>, nil ] optional image objects associated with the message
  # @param tool_calls [ Hash, Array<Hash>, nil ] optional tool calls made in the message
  def initialize(role:, content:, thinking: nil, images: nil, tool_calls: nil, **)
    @role, @content, @thinking, @images, @tool_calls =
      role, content, thinking, (Array(images) if images),
      (Array(tool_calls) if tool_calls)
  end
end

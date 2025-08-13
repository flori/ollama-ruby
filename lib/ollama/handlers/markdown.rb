require 'term/ansicolor'
require 'kramdown/ansi'

# A handler that processes responses by rendering them as ANSI-markdown output.
#
# This class is designed to display streaming or non-streaming responses in a
# formatted markdown style using ANSI escape codes for terminal rendering.
# It supports both continuous and single-message display modes, making it
# suitable for interactive terminal applications where styled text output is
# desired.
#
# @example Displaying a response as markdown
#   ollama.generate(model: 'llama3.1', prompt: 'Hello World', &Markdown)
class Ollama::Handlers::Markdown
  include Ollama::Handlers::Concern
  include Term::ANSIColor

  # The initialize method sets up a new handler instance with the specified
  # output destination and streaming behavior.
  #
  # @param output [ IO ] the output stream to be used for handling responses, defaults to $stdout
  # @param stream [ TrueClass, FalseClass ] whether to enable streaming mode, defaults to true
  def initialize(output: $stdout, stream: true)
    super(output:)
    @stream      = stream
    @output.sync = @stream
    @content     = ''
  end

  # The call method processes a response by rendering its content as
  # ANSI-markdown.
  #
  # This method handles the display of response content in a formatted markdown
  # style using ANSI escape codes for terminal rendering. It supports both
  # streaming and non-streaming modes, allowing for continuous updates or
  # single-message display.
  #
  # @param response [ Ollama::Response ] the response object containing content
  # to be rendered
  #
  # @return [ self ] returns the handler instance itself after processing the
  # response
  def call(response)
    if content = response.response || response.message&.content
      if @stream
        @content << content
        markdown_content = Kramdown::ANSI.parse(@content)
        @output.print clear_screen, move_home, markdown_content
      else
        markdown_content = Kramdown::ANSI.parse(content)
        @output.print markdown_content
      end
    end
    self
  end
end

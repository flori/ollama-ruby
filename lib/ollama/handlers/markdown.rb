require 'term/ansicolor'
require 'kramdown/ansi'

class Ollama::Handlers::Markdown
  include Ollama::Handlers::Concern
  include Term::ANSIColor

  def initialize(output: $stdout, stream: true)
    super(output:)
    @stream      = stream
    @output.sync = @stream
    @content     = ''
  end

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

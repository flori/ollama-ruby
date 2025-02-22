require 'term/ansicolor'
require 'kramdown/ansi'

class Ollama::Handlers::Markdown
  include Ollama::Handlers::Concern
  include Term::ANSIColor

  def initialize(output: $stdout)
    super
    @output.sync = true
    @content     = ''
  end

  def call(response)
    if content = response.response || response.message&.content
      @content << content
      markdown_content = Kramdown::ANSI.parse(@content)
      @output.print clear_screen, move_home, markdown_content
    end
    self
  end
end

class Ollama::Handlers::Print
  include Ollama::Handlers::Concern

  def initialize(output: $stdout)
    super
    @output.sync = true
  end

  def call(response)
    if content = response.response || response.message&.content
      @output.print content
    end
    response.done and @output.puts
    self
  end
end

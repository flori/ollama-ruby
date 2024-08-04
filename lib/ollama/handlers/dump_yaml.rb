class Ollama::Handlers::DumpYAML
  include Ollama::Handlers::Concern

  def call(response)
    @output.puts Psych.dump(response)
    self
  end
end

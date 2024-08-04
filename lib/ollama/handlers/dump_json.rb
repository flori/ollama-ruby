class Ollama::Handlers::DumpJSON
  include Ollama::Handlers::Concern

  def call(response)
    @output.puts JSON::pretty_generate(response, allow_nan: true, max_nesting: false)
    self
  end
end

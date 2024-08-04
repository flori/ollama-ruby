class Ollama::Handlers::NOP
  include Ollama::Handlers::Concern

  def call(response)
    self
  end
end

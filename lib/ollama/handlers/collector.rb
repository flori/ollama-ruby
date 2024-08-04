class Ollama::Handlers::Collector
  include Ollama::Handlers::Concern

  def initialize(output: $stdout)
    super
    @array = []
  end

  def call(response)
    @array << response
    self
  end

  def result
    @array
  end
end

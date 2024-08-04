class Ollama::Handlers::Single
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
    @array.size <= 1 ? @array.first : @array
  end
end

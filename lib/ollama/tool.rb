class Ollama::Tool
  include Ollama::DTO

  attr_reader :type, :function

  def initialize(type:, function:)
    @type, @function = type, function.to_hash
  end
end

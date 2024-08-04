class Ollama::Tool::Function::Parameters::Property
  include Ollama::DTO

  attr_reader :type, :description, :enum

  def initialize(type:, description:, enum: nil)
    @type, @description, @enum = type, description, Array(enum)
  end
end

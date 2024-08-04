class Ollama::Tool::Function
  include Ollama::DTO

  attr_reader :name, :description, :parameters, :required

  def initialize(name:, description:, parameters: nil, required: nil)
    @name, @description, @parameters, @required =
      name, description, (Hash(parameters) if parameters),
      (Array(required) if required)
  end
end

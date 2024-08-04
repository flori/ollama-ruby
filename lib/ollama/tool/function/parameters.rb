class Ollama::Tool::Function::Parameters
  include Ollama::DTO

  attr_reader :type, :properties, :required

  def initialize(type:, properties:, required:)
    @type, @properties, @required =
      type, Hash(properties).transform_values(&:to_hash), Array(required)
  end
end

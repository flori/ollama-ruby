class Ollama::Message
  include Ollama::DTO

  attr_reader :role, :content, :thinking, :images

  def initialize(role:, content:, thinking: nil, images: nil, **)
    @role, @content, @thinking, @images  =
      role, content, thinking, (Array(images) if images)
  end
end

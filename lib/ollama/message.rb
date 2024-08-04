class Ollama::Message
  include Ollama::DTO

  attr_reader :role, :content, :images

  def initialize(role:, content:, images: nil, **)
    @role, @content, @images = role, content, (Array(images) if images)
  end
end

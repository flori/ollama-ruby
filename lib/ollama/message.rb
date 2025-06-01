class Ollama::Message
  include Ollama::DTO

  attr_reader :role, :content, :thinking, :images

  def initialize(role:, content:, thinking: nil, images: nil, tool_calls: nil, **)
    @role, @content, @thinking, @images, @tool_calls =
      role, content, thinking, (Array(images) if images),
      (Array(tool_calls) if tool_calls)
  end
end

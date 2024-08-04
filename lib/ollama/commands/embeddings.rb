class Ollama::Commands::Embeddings
  include Ollama::DTO

  def self.path
    '/api/embeddings'
  end

  def initialize(model:, prompt:, options: nil, keep_alive: nil)
    @model, @prompt, @options, @keep_alive, @stream =
      model, prompt, options, keep_alive, false
  end

  attr_reader :model, :prompt, :options, :keep_alive, :stream

  attr_writer :client

  def perform(handler)
    @client.request(method: :post, path: self.class.path, body: to_json, stream:, handler:)
  end
end

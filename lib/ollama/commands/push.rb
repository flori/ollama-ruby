class Ollama::Commands::Push
  include Ollama::DTO

  def self.path
    '/api/push'
  end

  def initialize(model:, insecure: nil, stream: true)
    @model, @insecure, @stream = model, insecure, stream
  end

  attr_reader :model, :insecure, :stream

  attr_writer :client

  def perform(handler)
    @client.request(method: :post, path: self.class.path, body: to_json, stream:, handler:)
  end
end

class Ollama::Commands::Copy
  include Ollama::DTO

  def self.path
    '/api/copy'
  end

  def initialize(source:, destination:)
    @source, @destination, @stream = source, destination, false
  end

  attr_reader :source, :destination, :stream

  attr_writer :client

  def perform(handler)
    @client.request(method: :post, path: self.class.path, body: to_json, stream:, handler:)
  end
end

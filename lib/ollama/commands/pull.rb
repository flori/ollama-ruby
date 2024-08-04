class Ollama::Commands::Pull
  include Ollama::DTO

  def self.path
    '/api/pull'
  end

  def initialize(name:, insecure: nil, stream: true)
    @name, @insecure, @stream = name, insecure, stream
  end

  attr_reader :name, :insecure, :stream

  attr_writer :client

  def perform(handler)
    @client.request(method: :post, path: self.class.path, body: to_json, stream:, handler:)
  end
end

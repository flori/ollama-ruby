class Ollama::Commands::Delete
  include Ollama::DTO

  def self.path
    '/api/delete'
  end

  def initialize(name:)
    @name, @stream = name, false
  end

  attr_reader :name, :stream

  attr_writer :client

  def perform(handler)
    @client.request(method: :delete, path: self.class.path, body: to_json, stream:, handler:)
  end
end

class Ollama::Commands::Version
  def self.path
    '/api/version'
  end

  def initialize()
    @stream = false
  end

  attr_reader :stream

  attr_writer :client

  def perform(handler)
    @client.request(method: :get, path: self.class.path, stream:, handler:)
  end
end

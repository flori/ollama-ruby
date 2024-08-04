class Ollama::Commands::Show
  include Ollama::DTO

  def self.path
    '/api/show'
  end

  def initialize(name:, verbose: nil)
    @name, @verbose = name, verbose
    @stream = false
  end

  attr_reader :name, :verbose, :stream

  attr_writer :client

  def perform(handler)
    @client.request(method: :post, path: self.class.path, body: to_json, stream:, handler:)
  end
end

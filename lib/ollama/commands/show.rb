class Ollama::Commands::Show
  include Ollama::DTO

  def self.path
    '/api/show'
  end

  def initialize(model:, verbose: nil)
    @model, @verbose = model, verbose
    @stream = false
  end

  attr_reader :model, :verbose, :stream

  attr_writer :client

  def perform(handler)
    @client.request(method: :post, path: self.class.path, body: to_json, stream:, handler:)
  end
end

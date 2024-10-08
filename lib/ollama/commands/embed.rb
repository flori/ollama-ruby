class Ollama::Commands::Embed
  include Ollama::DTO

  def self.path
    '/api/embed'
  end

  def initialize(model:, input:, options: nil, truncate: nil, keep_alive: nil)
    @model, @input, @options, @truncate, @keep_alive =
      model, input, options, truncate, keep_alive
    @stream = false
  end

  attr_reader :model, :input, :options, :truncate, :keep_alive, :stream

  attr_writer :client

  def perform(handler)
    @client.request(method: :post, path: self.class.path, body: to_json, stream:, handler:)
  end
end

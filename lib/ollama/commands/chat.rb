class Ollama::Commands::Chat
  include Ollama::DTO

  def self.path
    '/api/chat'
  end

  def initialize(model:, messages:, tools: nil, format: nil, options: nil, stream: nil, keep_alive: nil)
    @model, @messages, @tools, @format, @options, @stream, @keep_alive =
      model, as_array_of_hashes(messages), as_array_of_hashes(tools),
      format, options, stream, keep_alive
  end

  attr_reader :model, :messages, :tools, :format, :options, :stream, :keep_alive

  attr_writer :client

  def perform(handler)
    @client.request(method: :post, path: self.class.path, body: to_json, stream:, handler:)
  end
end

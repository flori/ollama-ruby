class Ollama::Commands::Create
  include Ollama::DTO

  def self.path
    '/api/create'
  end

  def initialize(name:, modelfile: nil, quantize: nil, stream: nil, path: nil)
    @name, @modelfile, @quantize, @stream, @path =
      name, modelfile, quantize, stream, path
  end

  attr_reader :name, :modelfile, :quantize, :stream, :path

  attr_writer :client

  def perform(handler)
    @client.request(method: :post, path: self.class.path, body: to_json, stream:, handler:)
  end
end

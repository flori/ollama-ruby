class Ollama::Commands::Create
  include Ollama::DTO

  def self.path
    '/api/create'
  end

  def initialize(model:, from: nil, files: nil, adapters: nil, template: nil, license: nil, system: nil, parameters: nil, messages: nil, stream: true, quantize: nil)
    @model, @from, @files, @adapters, @license, @system, @parameters, @messages, @stream, @quantize =
      model, from, as_hash(files), as_hash(adapters), as_array(license), system,
      as_hash(parameters), as_array_of_hashes(messages), stream, quantize
  end

  attr_reader :model, :from, :files, :adapters, :license, :system, :parameters, :messages, :stream, :quantize

  attr_writer :client

  def perform(handler)
    @client.request(method: :post, path: self.class.path, body: to_json, stream:, handler:)
  end
end

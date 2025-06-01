class Ollama::Commands::Generate
  include Ollama::DTO

  def self.path
    '/api/generate'
  end

  def initialize(model:, prompt:, suffix: nil, images: nil, format: nil, options: nil, system: nil, template: nil, context: nil, stream: nil, raw: nil, keep_alive: nil, think: nil)
    @model, @prompt, @suffix, @images, @format, @options, @system, @template, @context, @stream, @raw, @keep_alive, @think =
      model, prompt, suffix, (Array(images) if images), format, options, system, template, context, stream, raw, keep_alive, think
  end

  attr_reader :model, :prompt, :suffix, :images, :format, :options, :system,
    :template, :context, :stream, :raw, :keep_alive, :think

  attr_writer :client

  def perform(handler)
    @client.request(method: :post, path: self.class.path, body: to_json, stream:, handler:)
  end
end

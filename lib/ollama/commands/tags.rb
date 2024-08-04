class Ollama::Commands::Tags
  def self.path
    '/api/tags'
  end

  def initialize(**parameters)
    parameters.empty? or raise ArgumentError,
      "Invalid parameters: #{parameters.keys * ' '}"
    @stream = false
  end

  attr_reader :stream

  attr_writer :client

  def perform(handler)
    @client.request(method: :get, path: self.class.path, stream:, handler:)
  end
end

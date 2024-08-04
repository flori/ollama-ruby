class Ollama::Commands::Ps
  def self.path
    '/api/ps'
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

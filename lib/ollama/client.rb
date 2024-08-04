require 'tins/xt/string_camelize'
require 'tins/annotate'
require 'excon'

class Ollama::Client
end
require 'ollama/client/doc'
require 'ollama/client/command'

class Ollama::Client
  include Tins::Annotate
  include Ollama::Handlers
  include Ollama::Client::Command

  annotate :doc

  def initialize(base_url: nil, output: $stdout, connect_timeout: nil, read_timeout: nil, write_timeout: nil, debug: nil)
    base_url.nil? and base_url = ENV.fetch('OLLAMA_URL') do
      raise ArgumentError,
        'missing :base_url parameter or OLLAMA_URL environment variable'
    end
    base_url.is_a? URI or base_url = URI.parse(base_url)
		base_url.is_a?(URI::HTTP) || base_url.is_a?(URI::HTTPS) or
			raise ArgumentError, "require #{base_url.inspect} to be http/https-URI"
    @ssl_verify_peer = base_url.query.to_s.split(?&).inject({}) { |h, l|
      h.merge Hash[*l.split(?=)]
    }['ssl_verify_peer'] != 'false'
    @base_url, @output, @connect_timeout, @read_timeout, @write_timeout, @debug =
      base_url, output, connect_timeout, read_timeout, write_timeout, debug
  end

  attr_accessor :output

  def ssl_verify_peer?
    !!@ssl_verify_peer
  end

  command(:chat, default_handler: Single, stream_handler: Collector)

  command(:generate, default_handler: Single, stream_handler: Collector)

  command(:tags, default_handler: Single)

  command(:show, default_handler: Single)

  command(:create, default_handler: Single, stream_handler: Progress)

  command(:copy, default_handler: Single)

  command(:delete, default_handler: Single)

  command(:pull, default_handler: Single, stream_handler: Progress)

  command(:push, default_handler: Single, stream_handler: Progress)

  command(:embed, default_handler: Single)

  command(:embeddings, default_handler: Single)

  command(:ps, default_handler: Single)

  def commands
    doc_annotations.sort_by(&:first).transpose.last
  end

  doc Doc.new(:help)
  def help
    @output.puts "Commands: %s" % commands.join(?,)
  end

  def request(method:, path:, handler:, body: nil, stream: nil)
    url = @base_url + path
    responses = Enumerator.new do |yielder|
      if stream
        response_block = -> chunk, remaining_bytes, total_bytes do
          response_line = parse_json(chunk)
          response_line and yielder.yield response_line
        end
        response = excon(url).send(method, headers:, body:, response_block:)
      else
        response = excon(url).send(method, headers:, body:)
      end

      case response.status
      when 200
        response.body.each_line do |l|
          response_line = parse_json(l)
          response_line and yielder.yield response_line
        end
      when 404
        raise Ollama::Errors::NotFoundError, "#{response.status} #{response.body.inspect}"
      else
        raise Ollama::Errors::Error, "#{response.status} #{response.body.inspect}"
      end
    end
    responses.each { |response| handler.call(response) }
    self
  rescue Excon::Errors::SocketError => e
    raise Ollama::Errors::SocketError, "Caught #{e.class} #{e.message.inspect} for #{url.to_s.inspect}"
  rescue Excon::Errors::Timeout => e
    raise Ollama::Errors::TimeoutError, "Caught #{e.class} #{e.message.inspect} for #{url.to_s.inspect}"
  rescue Excon::Error => e
    raise Ollama::Errors::Error, "Caught #{e.class} #{e.message.inspect} for #{url.to_s.inspect}"
  end

  def inspect
    "#<#{self.class}@#{@base_url.to_s}>"
  end

  alias to_s inspect

  private

  def headers
    {
      'User-Agent'   => '%s/%s' % [ self.class, Ollama::VERSION ],
      'Content-Type' => 'application/json; charset=utf-8',
    }
  end

  def excon(url)
    params = {
      connect_timeout: @connect_timeout,
      read_timeout:    @read_timeout,
      write_timeout:   @write_timeout,
      ssl_verify_peer: @ssl_verify_peer,
      debug:           @debug,
    }.compact
    Excon.new(url, params)
  end

  def parse_json(string)
    JSON.parse(string, object_class: Ollama::Response)
  rescue JSON::ParserError
    return
  end
end

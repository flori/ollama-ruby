require 'tempfile'
require 'tins/unit'
require 'infobar'
require 'mime-types'
require 'stringio'
require 'ollama/utils/cache_fetcher'

class Ollama::Utils::Fetcher
  module HeaderExtension
    attr_accessor :content_type

    attr_accessor :ex

    def self.failed
      object = StringIO.new.extend(self)
      object.content_type = MIME::Types['text/plain'].first
      object
    end
  end

  class RetryWithoutStreaming < StandardError; end

  def self.get(url, **options, &block)
    cache = options.delete(:cache) and
      cache = Ollama::Utils::CacheFetcher.new(cache)
    if result = cache&.get(url, &block)
      infobar.puts "Getting #{url.to_s.inspect} from cache."
      return result
    else
      new(**options).send(:get, url) do |tmp|
        result = block.(tmp)
        if cache && !tmp.is_a?(StringIO)
          tmp.rewind
          cache.put(url, tmp)
        end
        result
      end
    end
  end

  def self.normalize_url(url)
    url = url.to_s
    url = URI.decode_uri_component(url)
    url = url.sub(/#.*/, '')
    URI::Parser.new.escape(url).to_s
  end

  def self.read(filename, &block)
    if File.exist?(filename)
      File.open(filename) do |file|
        file.extend(Ollama::Utils::Fetcher::HeaderExtension)
        file.content_type = MIME::Types.type_for(filename).first
        block.(file)
      end
    else
      STDERR.puts "File #{filename.to_s.inspect} doesn't exist."
    end
  end

  def self.execute(command, &block)
    Tempfile.open do |tmp|
      IO.popen(command) do |command|
        until command.eof?
          tmp.write command.read(1 << 14)
        end
        tmp.rewind
        tmp.extend(Ollama::Utils::Fetcher::HeaderExtension)
        tmp.content_type = MIME::Types['text/plain'].first
        block.(tmp)
      end
    end
  rescue => e
    STDERR.puts "Cannot execute #{command.inspect} (#{e})"
    if @debug && !e.is_a?(RuntimeError)
      STDERR.puts "#{e.backtrace * ?\n}"
    end
    yield HeaderExtension.failed
  end

  def initialize(debug: false, http_options: {})
    @debug        = debug
    @started      = false
    @streaming    = true
    @http_options = http_options
  end

  private

  def excon(url, **options)
    url = self.class.normalize_url(url)
    Excon.new(url, options.merge(@http_options))
  end

  def get(url, &block)
    response = nil
    Tempfile.open do |tmp|
      infobar.label = 'Getting'
      if @streaming
        response = excon(url, headers:, response_block: callback(tmp)).request(method: :get)
        response.status != 200 || !@started and raise RetryWithoutStreaming
        decorate_io(tmp, response)
        infobar.finish
        block.(tmp)
      else
        response = excon(url, headers:, middlewares:).request(method: :get)
        if response.status != 200
          raise "invalid response status code"
        end
        body = response.body
        tmp.print body
        infobar.update(message: message(body.size, body.size), force: true)
        decorate_io(tmp, response)
        infobar.finish
        block.(tmp)
      end
    end
  rescue RetryWithoutStreaming
    @streaming = false
    retry
  rescue => e
    STDERR.puts "Cannot get #{url.to_s.inspect} (#{e}): #{response&.status_line || 'n/a'}"
    if @debug && !e.is_a?(RuntimeError)
      STDERR.puts "#{e.backtrace * ?\n}"
    end
    yield HeaderExtension.failed
  end

  def headers
    {
      'User-Agent' => Ollama::Client.user_agent,
    }
  end

  def middlewares
    (Excon.defaults[:middlewares] + [ Excon::Middleware::RedirectFollower ]).uniq
  end

  private

  def decorate_io(tmp, response)
    tmp.rewind
    tmp.extend(HeaderExtension)
    if content_type = MIME::Types[response.headers['content-type']].first
      tmp.content_type = content_type
    end
    if cache_control = response.headers['cache-control'] and
        cache_control !~ /no-store|no-cache/ and
        ex = cache_control[/s-maxage\s*=\s*(\d+)/, 1] || cache_control[/max-age\s*=\s*(\d+)/, 1]
    then
      tmp.ex = ex.to_i
    end
  end

  def callback(tmp)
    -> chunk, remaining_bytes, total_bytes do
      total   = total_bytes or next
      current = total_bytes - remaining_bytes
      if @started
        infobar.counter.progress(by: total - current)
      else
        @started = true
        infobar.counter.reset(total:, current:)
      end
      infobar.update(message: message(current, total), force: true)
      tmp.print(chunk)
    end
  end

  def message(current, total)
    progress = '%s/%s' % [ current, total ].map {
      Tins::Unit.format(_1, format: '%.2f %U')
    }
    '%l ' + progress + ' in %te, ETA %e @%E'
  end
end

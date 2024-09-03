require 'tempfile'
require 'tins/unit'
require 'infobar'
require 'mime-types'

class Ollama::Utils::Fetcher
  module ContentType
    attr_accessor :content_type
  end

  class RetryWithoutStreaming < StandardError; end

  def initialize
    @started   = false
    @streaming = true
  end

  def self.get(url, &block)
    new.get(url, &block)
  end

  def get(url, &block)
    response = nil
    Tempfile.open do |tmp|
      infobar.label = 'Getting'
      if @streaming
        response = Excon.get(url, headers:, response_block: callback(tmp))
        response.status != 200 || !@started and raise RetryWithoutStreaming
        decorate_io(tmp, response)
        infobar.finish
        block.(tmp)
      else
        response = Excon.get(url, headers:, middlewares:)
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
    STDERR.puts "Cannot get #{url.to_s.inspect} (#{e}): #{response&.status_line}"
    unless e.is_a?(RuntimeError)
      STDERR.puts "#{e.backtrace * ?\n}"
    end
    yield nil
  end

  def headers
    {
      'User-Agent' => Ollama::Client.user_agent,
    }
  end

  def middlewares
    (Excon.defaults[:middlewares] + [ Excon::Middleware::RedirectFollower ]).uniq
  end

  def decorate_io(tmp, response)
    tmp.rewind
    tmp.extend(ContentType)
    if content_type = MIME::Types[response.headers['content-type']].first
      tmp.content_type = content_type
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

  def self.read(filename, &block)
    if File.exist?(filename)
      File.open(filename) do |file|
        file.extend(Ollama::Utils::Fetcher::ContentType)
        file.content_type = MIME::Types.type_for(filename).first
        block.(file)
      end
    end
  end
end
require 'digest/md5'

class Ollama::Utils::CacheFetcher
  def initialize(cache)
    @cache = cache
  end

  def get(url, &block)
    block or raise ArgumentError, 'require block argument'
    body         = @cache[key(:body, url)]
    content_type = @cache[key(:content_type, url)]
    content_type = MIME::Types[content_type].first
    if body && content_type
      io = StringIO.new(body)
      io.rewind
      io.extend(Ollama::Utils::Fetcher::ContentType)
      io.content_type = content_type
      block.(io)
    end
  end

  def put(url, io)
    io.rewind
    body = io.read
    body.empty? and return
    content_type = io.content_type
    content_type.nil? and return
    @cache[key(:body, url)]          = body
    @cache[key(:content_type,  url)] = content_type.to_s
    self
  end

  private

  def key(type, url)
    [ type, Digest::MD5.hexdigest(url) ] * ?-
  end
end

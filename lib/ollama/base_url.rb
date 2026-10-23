# A module that provides URL normalization for the Ollama base URL.
#
# This module is extended into the Ollama namespace, making
# +Ollama.base_url+ the public entry point for resolving a
# user-supplied host specification into a fully-qualified
# {URI} suitable for HTTP(S) communication with an Ollama server.
#
# @example Resolving a bare host:port
#   Ollama.base_url('127.0.0.1:11434')
#   # => #<URI::HTTP http://127.0.0.1:11434>
#
# @example Resolving a fully-qualified URL (unchanged)
#   Ollama.base_url('https://mybox:11434/v1')
#   # => #<URI::HTTPS https://mybox:11434/v1>
module Ollama::BaseURL
  # Normalizes a base URL specification into a {URI} object.
  #
  # Accepts either a {URI} instance or a String. If the String
  # does not contain an explicit +http://+ or +https://+ scheme,
  # one is prepended automatically.
  #
  # @param spec [URI, String] the host specification or full URL
  # @param fallback [Boolean] when true (default), a missing or
  #   unrecognized scheme triggers an automatic +http://+ prepend.
  #   When false, unrecognized schemes return +nil+.
  # @return [URI, nil] the normalized URI, or +nil+ if +fallback+
  #   is false and the scheme is not http/https.
  #
  # @example Bare IP:port (scheme prepended)
  #   base_url('127.0.0.1:11434')
  #   # => #<URI::HTTP http://127.0.0.1:11434>
  #
  # @example Fully-qualified URL (passed through)
  #   base_url('https://mybox:11434/v1')
  #   # => #<URI::HTTPS https://mybox:11434/v1>
  def base_url(spec, fallback: true)
    uri = nil
    begin
      uri = spec.is_a?(URI) ? spec : URI.parse(spec)
    rescue URI::InvalidURIError
      if fallback
        return base_url('http://%s' % spec, fallback: false)
      else
        return
      end
    end
    case
    when uri&.scheme =~ /\Ahttps?\z/
      uri
    when fallback
      base_url('http://%s' % spec, fallback: false)
    end
  end
end

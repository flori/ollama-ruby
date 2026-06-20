require 'digest'

# Provides utility methods for computing SHA256 digests of binary streams.
# This module is designed as a mixin to provide consistent hashing logic across
# different components, ensuring that IO objects are handled safely and
# efficiently.
module Ollama::Digester
  private

  # Calculates the SHA256 checksum of a given IO object.
  #
  # The method ensures the stream is reset both before and after processing to
  # maintain the state of the IO object. It reads the content in chunks to
  # minimize memory footprint when dealing with large binary files.
  #
  # @param io [ IO ] the binary data stream to be hashed
  # @param chunk_size [ Integer ] the size of chunks to read from the IO stream (default: 16384)
  #
  # @return [ String ] the resulting SHA256 digest formatted as 'sha256:<hex>'
  def compute_digest(io, chunk_size: 1 << 16)
    io.rewind
    digest = Digest::SHA256.new
    until io.eof?
      digest << io.read(chunk_size)
    end
    'sha256:%s' % digest.hexdigest
  ensure
    io.rewind
  end

  # Ensures a SHA256 digest is prefixed with 'sha256:'.
  #
  # If the provided string consists of exactly 64 hexadecimal characters,
  # the prefix is prepended. Otherwise, the original string is returned.
  #
  # @param digest [ String, nil ] the digest to be prefixed
  # @return [ String, nil ] the prefixed digest or the original value
  def prefix_sha256(digest)
    digest&.sub(/\A(?=\h{64}\z)/, 'sha256:')
  end
end

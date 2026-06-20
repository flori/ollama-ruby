require 'ollama/digester'

# A command class that represents the blob existence check API endpoint for
# Ollama.
#
# This class is used to interact with the Ollama API's blobs endpoint using a
# HEAD request to verify if a specific binary blob (identified by its digest)
# already exists on the server. This is particularly useful for optimizing
# model uploads by avoiding redundant transfers of large files.
#
# @example Checking if a blob exists
#   exists = ollama.blob_exists?(digest: 'sha256:...')
class Ollama::Commands::BlobExists
  include Ollama::Digester

  # The initialize method sets up a new instance with the target digest.
  #
  # This method initializes the command object with the specific digest of the
  # blob being checked and explicitly disables streaming as HEAD requests
  # are inherently non-streaming.
  #
  # @param digest [ String, nil ] the SHA256 digest of the blob (e.g., 'sha256:...')
  # @param blob [ IO, nil ] the binary data stream to be hashed if no digest is
  #   provided
  def initialize(digest: nil, blob: nil)
    digest = prefix_sha256(digest)
    if digest.nil? && blob
      digest = compute_digest(blob)
    end
    digest or raise ArgumentError, 'require digest or blob to perform'
    @digest, @stream = digest, false
  end

  # The digest attribute reader returns the target blob digest.
  #
  # @return [ String ] the SHA256 digest of the blob
  attr_reader :digest

  # The stream attribute reader returns the streaming behavior setting.
  #
  # @return [ FalseClass ] the streaming behavior flag (always false for this command)
  attr_reader :stream

  # The client attribute writer allows setting the client instance associated
  # with the object.
  #
  # @attr_writer [ Ollama::Client ] the assigned client instance
  attr_writer :client

  # The path method constructs the API endpoint URL for a specific binary blob.
  # It interpolates the target blob's digest into the path string to create the
  # correct resource identifier for the Ollama API.
  #
  # @return [ String ] the API endpoint path for the blob
  def path
    "/api/blobs/#{digest}"
  end

  # The perform method executes the existence check request using a HEAD method.
  #
  # This method initiates a HEAD request to the '/api/blobs/:digest' endpoint.
  # A successful response (typically 200 OK) indicates the blob exists, while
  # a 404 Not Found indicates it does not.
  #
  # @param handler [ Ollama::Handler ] the handler object responsible for
  #   processing API responses
  #
  # @return [ self ] returns the current instance after initiating the request
  def perform(handler)
    @client.request(method: :head, path:, stream:, handler:)
    self
  end
end

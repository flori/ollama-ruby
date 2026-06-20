require 'ollama/digester'

# A command class that represents the push blob API endpoint for Ollama.
#
# This class is used to upload raw binary files (blobs) to the Ollama server.
# It accepts the content to be uploaded and automatically calculates the
# required SHA256 digest to target the correct API endpoint.
#
# @example Preparing a push blob command with a file
#   command = Ollama::Commands::PushBlob.new(body: File.open('model.gguf', 'rb'))
class Ollama::Commands::PushBlob
  include Ollama::Digester

  # The initialize method sets up a new instance and calculates the content
  # digest.
  #
  # This method ensures the body is an IO-like object and computes the SHA256
  # hash of the content to be used as the target endpoint path.
  #
  # @param body [ IO, String ] the binary content or file handle to upload
  # @param digest [ String, nil ] optional precomputed SHA256 digest. If provided,
  #   it takes precedence over computing one from the body.
  def initialize(body:, digest: nil)
    @body   = body.respond_to?(:read) ? body : StringIO.new(body.to_str)
    digest = prefix_sha256(digest)
    @digest = digest || compute_digest(@body)
    @stream = false
  end

  # The body attribute reader returns the binary content to be uploaded to the
  # Ollama server.
  #
  # @attr_reader [ IO, String ] the raw image or model data used for the blob upload
  attr_reader :body

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

  # The path method returns the API endpoint path for pushing blobs.
  #
  # This method interpolates the digest into the URL to target a specific blob.
  #
  # @return [ String ] the API endpoint path '/api/blobs/<digest>'
  def path
    "/api/blobs/#{digest}"
  end

  # The perform method is not used directly for file uploads in this
  # implementation, as the client uses a specialized streaming request method
  # to handle IO.
  # However, it's kept for interface consistency.
  #
  # @param handler [ Ollama::Handler ] the handler object responsible for processing API responses
  #
  # @return [ self ] returns the current instance after initiating the request
  def perform(handler)
    @client.blob_exists?(digest) or @client.upload_file(path:, body:, handler:)
    handler.result = digest
    self
  end
end

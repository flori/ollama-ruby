# A handler that outputs JSON representations of responses to the specified
# output stream.
#
# This class is designed to serialize and display API responses in JSON format,
# making it easy to inspect the raw data returned by Ollama commands. It
# implements the standard handler interface and can be used with any command
# that supports response processing.
#
# @example Using the DumpJSON handler to output response data as JSON
#   ollama.generate(model: 'llama3.1', prompt: 'Hello World', &DumpJSON)
class Ollama::Handlers::DumpJSON
  include Ollama::Handlers::Concern

  # The call method processes a response by outputting its JSON representation.
  #
  # This method takes a response object and serializes it into a formatted JSON
  # string, which is then written to the specified output stream. It is
  # designed to provide detailed inspection of API responses in a
  # human-readable format.
  #
  # @param response [ Ollama::Response ] the response object to be serialized and output
  #
  # @return [ self ] returns the handler instance itself after processing the response
  def call(response)
    @output.puts JSON::pretty_generate(response, allow_nan: true, max_nesting: false)
    self
  end
end

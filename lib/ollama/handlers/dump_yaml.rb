# A handler that outputs YAML representations of responses to the specified
# output stream.
#
# This class is designed to serialize and display API responses in YAML format,
# making it easy to inspect the raw data returned by Ollama commands. It
# implements the standard handler interface and can be used with any command
# that supports response processing.
#
# @example Using the DumpYAML handler to output response data as YAML
#   ollama.generate(model: 'llama3.1', prompt: 'Hello World', &DumpYAML)
class Ollama::Handlers::DumpYAML
  include Ollama::Handlers::Concern

  # The call method processes a response by outputting its YAML representation.
  #
  # This method takes a response object and serializes it into YAML format,
  # writing the result to the configured output stream. It is designed to
  # handle API responses that need to be displayed or logged in a structured
  # YAML format for debugging or inspection purposes.
  #
  # @param response [ Ollama::Response ] the response object to be serialized
  # and output
  #
  # @return [ self ] returns the handler instance itself after processing the
  # response
  def call(response)
    @output.puts Psych.dump(response)
    self
  end
end

require 'term/ansicolor'

# A class that generates documentation links for Ollama API commands.
#
# This class is responsible for creating human-readable documentation
# references for various Ollama API endpoints. It maps command names to their
# corresponding documentation URLs, providing easy access to API documentation
# for developers working with the Ollama client.
#
# @example Generating a documentation link for a command
#   doc = Ollama::Client::Doc.new(:generate)
#   puts doc.to_s # => hyperlink to generate command documentation
class Ollama::Client::Doc
  include Term::ANSIColor

  def initialize(name)
    @name = name
    @url  = Hash.new('https://github.com/ollama/ollama/blob/main/docs/api.md').merge(
      generate:         'https://github.com/ollama/ollama/blob/main/docs/api.md#generate-a-completion',
      chat:             'https://github.com/ollama/ollama/blob/main/docs/api.md#generate-a-chat-completion',
      create:           'https://github.com/ollama/ollama/blob/main/docs/api.md#create-a-model',
      tags:             'https://github.com/ollama/ollama/blob/main/docs/api.md#list-local-models',
      show:             'https://github.com/ollama/ollama/blob/main/docs/api.md#show-model-information',
      copy:             'https://github.com/ollama/ollama/blob/main/docs/api.md#copy-a-model',
      delete:           'https://github.com/ollama/ollama/blob/main/docs/api.md#delete-a-model',
      pull:             'https://github.com/ollama/ollama/blob/main/docs/api.md#pull-a-model',
      push:             'https://github.com/ollama/ollama/blob/main/docs/api.md#push-a-model',
      embeddings:       'https://github.com/ollama/ollama/blob/main/docs/api.md#generate-embeddings', # superseded by /api/embed
      embed:            'https://github.com/ollama/ollama/blob/main/docs/api.md#generate-embeddings',
      ps:               'https://github.com/ollama/ollama/blob/main/docs/api.md#list-running-models',
      version:          'https://github.com/ollama/ollama/blob/main/docs/api.md#version',
    )[name]
  end

  # The to_s method converts the documentation object to a string representation.
  #
  # This method generates a human-readable string that includes a hyperlink to the
  # corresponding Ollama API documentation for the command, if a URL is available.
  # The resulting string can be used for display purposes or logging.
  #
  # @return [ String ] a string representation containing the formatted documentation link
  #                     or an empty string if no URL is defined for the command
  def to_s
    (hyperlink(@url) { @name } if @url).to_s
  end
end

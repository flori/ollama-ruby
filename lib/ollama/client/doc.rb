require 'term/ansicolor'

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
    )[name]
  end

  def to_s
    (hyperlink(@url) { @name } if @url).to_s
  end
end

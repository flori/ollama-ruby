require 'json'
require 'excon'
require 'tins'
require 'tins/xt/full'
require 'tins/xt/hash_union'
require 'tins/xt/string_camelize'

module Ollama
end

require 'ollama/handlers'
module Ollama
  include Ollama::Handlers
end

require 'ollama/version'
require 'ollama/errors'
require 'ollama/dto'
require 'ollama/image'
require 'ollama/message'
require 'ollama/tool'
require 'ollama/tool/function'
require 'ollama/tool/function/parameters'
require 'ollama/tool/function/parameters/property'
require 'ollama/response'
require 'ollama/options'

class Ollama::Commands
end
require 'ollama/commands/generate'
require 'ollama/commands/chat'
require 'ollama/commands/create'
require 'ollama/commands/tags'
require 'ollama/commands/show'
require 'ollama/commands/copy'
require 'ollama/commands/delete'
require 'ollama/commands/pull'
require 'ollama/commands/push'
require 'ollama/commands/embed'
require 'ollama/commands/embeddings'
require 'ollama/commands/ps'
require 'ollama/commands/version'

require 'ollama/client'

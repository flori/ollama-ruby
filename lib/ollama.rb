require 'json'
require 'excon'
require 'tins'
require 'tins/xt/full'
require 'tins/xt/hash_union'
require 'tins/xt/string_camelize'

# The main module for the Ollama Ruby client library.
#
# This module serves as the root namespace for all components of the Ollama
# client library, providing access to core classes and functionality for
# interacting with the Ollama API. It includes handlers, commands, data
# transfer objects, and utility classes that enable communication with
# Ollama servers.
#
# @example Accessing core components
#   Ollama::Client
#   Ollama::Handlers
#   Ollama::Commands
#   Ollama::DTO
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

# A module that groups together various command classes used to interact with
# the Ollama API.
#
# This module serves as a namespace for all command implementations that
# correspond to specific Ollama API endpoints. It provides the structure and
# functionality needed to define and execute different types of operations such
# as chat conversations, model generation, model management, and other
# interactions with the Ollama server.
#
# @example Accessing command classes
#   Ollama::Commands::Chat
#   Ollama::Commands::Generate
#   Ollama::Commands::Create
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

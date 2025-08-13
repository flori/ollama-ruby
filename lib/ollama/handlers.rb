# A module that groups together various handler classes used to process
# responses from the Ollama API.
#
# Handlers are responsible for defining how API responses should be processed, displayed, or stored.
# They implement a common interface that allows them to be passed as arguments to client commands,
# providing flexibility in how response data is handled.
#
# @example Using a handler with a client command
#   ollama.generate(model: 'llama3.1', prompt: 'Hello World', &Print)
module Ollama::Handlers
end

require 'ollama/handlers/concern'
require 'ollama/handlers/collector'
require 'ollama/handlers/nop'
require 'ollama/handlers/single'
require 'ollama/handlers/markdown'
require 'ollama/handlers/progress'
require 'ollama/handlers/print'
require 'ollama/handlers/dump_json'
require 'ollama/handlers/dump_yaml'
require 'ollama/handlers/say'

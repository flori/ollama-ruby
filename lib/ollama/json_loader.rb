# A module that provides functionality for loading configuration data from JSON
# files.
#
# This module extends classes with a method to load configuration attributes
# from a JSON file, making it easy to initialize objects with settings stored
# in external files.

# @example Loading configuration from a JSON file
#   config = MyConfigClass.load_from_json('path/to/config.json')
module Ollama::JSONLoader
  # The load_from_json method loads configuration data from a JSON file.
  #
  # This method reads the specified JSON file and uses its contents to
  # initialize a new instance of the class by passing the parsed data
  # as keyword arguments to the constructor.
  #
  # @param path [ String ] the filesystem path to the JSON configuration file
  # @return [ self ] a new instance of the class initialized with the JSON data
  def load_from_json(path)
    json = File.read(path)
    new(**config_hash = JSON.parse(json, symbolize_names: true))
  end
end

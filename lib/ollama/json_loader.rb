module Ollama::JSONLoader
  def load_from_json(path)
    json = File.read(path)
    new(**config_hash = JSON.parse(json, symbolize_names: true))
  end
end

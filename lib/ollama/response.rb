class Ollama::Response < JSON::GenericObject
  def as_json(*)
    to_hash
  end
end

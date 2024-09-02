module Ollama::DTO
  extend Tins::Concern

  included do
    self.attributes = Set.new
  end

  module ClassMethods
    attr_accessor :attributes

    def from_hash(hash)
      new(**hash.transform_keys(&:to_sym))
    end

    def attr_reader(*names)
      super
      attributes.merge(names.map(&:to_sym))
    end
  end

  def as_array_of_hashes(obj)
    if obj.respond_to?(:to_hash)
      [ obj.to_hash ]
    elsif obj.respond_to?(:to_ary)
      obj.to_ary.map(&:to_hash)
    end
  end

  def as_json(*)
    self.class.attributes.each_with_object({}) { |a, h| h[a] = send(a) }.
      reject { _2.nil? || _2.ask_and_send(:size) == 0 }
  end

  alias to_hash as_json

  def to_json(*)
    as_json.to_json(*)
  end
end

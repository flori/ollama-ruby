module Ollama::Client::Command
  extend Tins::Concern

  module ClassMethods
    # Create Command +name+, if +stream+ was true, set stream_handler as
    # default, otherwise default_handler.
    def command(name, default_handler:, stream_handler: nil)
      klass = Ollama::Commands.const_get(name.to_s.camelize)
      doc Ollama::Client::Doc.new(name)
      define_method(name) do |**parameters, &handler|
        instance = klass.new(**parameters)
        instance.client = self
        unless handler
          instance.stream and stream_handler and
            handler ||= stream_handler
          handler ||= default_handler
        end
        handler.is_a?(Class) and handler = handler.new
        instance.perform(handler)
        handler.result if handler.respond_to?(:result)
      end
      self
    end
  end
end

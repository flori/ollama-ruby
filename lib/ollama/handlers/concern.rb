require 'tins/concern'
require 'tins/implement'

module Ollama::Handlers::Concern
  extend Tins::Concern
  extend Tins::Implement

  def initialize(output: $stdout)
    @output = output
  end

  attr_reader :output

  attr_reader :result

  implement :call

  def to_proc
    -> response { call(response) }
  end

  module ClassMethods
    def call(response)
      new.call(response)
    end

    def to_proc
      new.to_proc
    end
  end
end

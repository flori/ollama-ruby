require 'ollama/json_loader'

# A class that encapsulates configuration options for Ollama models.
#
# This class provides a structured way to define and manage various parameters
# that can be passed to Ollama models during generation or chat operations. It
# includes type validation to ensure that option values conform to expected
# data types, making it easier to work with model configurations
# programmatically.
#
# @example Creating an Options object with specific settings
#   options = Ollama::Options.new(
#     temperature: 0.7,
#     num_ctx: 8192,
#     top_p: 0.9
#   )
#
# [Options are explained in the parameters for the modelfile.](https://github.com/ollama/ollama/blob/main/docs/modelfile.md#parameter)
class Ollama::Options
  include Ollama::DTO
  extend Ollama::JSONLoader

  @@types = {
    numa:              [ false, true ],
    num_ctx:           Integer,
    num_batch:         Integer,
    num_gpu:           Integer,
    main_gpu:          Integer,
    low_vram:          [ false, true ],
    f16_kv:            [ false, true ],
    logits_all:        [ false, true ],
    vocab_only:        [ false, true ],
    use_mmap:          [ false, true ],
    use_mlock:         [ false, true ],
    num_thread:        Integer,
    num_keep:          Integer,
    seed:              Integer,
    num_predict:       Integer,
    top_k:             Integer,
    top_p:             Float,
    min_p:             Float,
    tfs_z:             Float,
    typical_p:         Float,
    repeat_last_n:     Integer,
    temperature:       Float,
    repeat_penalty:    Float,
    presence_penalty:  Float,
    frequency_penalty: Float,
    mirostat:          Integer,
    mirostat_tau:      Float,
    mirostat_eta:      Float,
    penalize_newline:  [ false, true ],
    stop:              Array,
  }

  @@types.each do |name, type|
    attr_reader name

    define_method("#{name}=") do |value|
      instance_variable_set(
        "@#{name}",
        if value.nil?
          nil
        else
          case type
          when Class
            send(type.name, value)
          when Array
            if type.include?(value)
              value
            else
              raise TypeError, "#{value} not in #{type * ?|}"
            end
          end
        end
      )
    end
  end

  class_eval %{
    def initialize(#{@@types.keys.map { "#{_1}: nil" }.join(', ') + ', **'})
      #{@@types.keys.map { "self.#{_1} = #{_1}" }.join(?\n)}
    end
  }

  # The [] method creates a new instance of the class using a hash of attributes.
  #
  # This class method provides a convenient way to instantiate an object by
  # passing a hash containing the desired attribute values. It converts the
  # hash keys to symbols and forwards them as keyword arguments to the
  # constructor.
  #
  # @param value [ Hash ] a hash containing the attribute names and their values
  #
  # @return [ self ] a new instance of the class initialized with the provided
  # attributes
  def self.[](value)
    new(**value.to_h)
  end
end

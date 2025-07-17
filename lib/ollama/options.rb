require 'ollama/json_loader'

# Options are explained in the parameters for the modelfile:
# https://github.com/ollama/ollama/blob/main/docs/modelfile.md#parameter
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

  def self.[](value)
    new(**value.to_h)
  end
end

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
# [Options are explained in the parameters for the modelfile.](https://github.com/ollama/ollama/blob/main/docs/modelfile.mdx)
class Ollama::Options
  include Ollama::DTO
  extend Ollama::JSONLoader

  # Hash defining the valid types for each configuration parameter
  # This is used for type validation in the setter methods
  @@types = {
    # NUMA (Non-Uniform Memory Access) support - enables NUMA awareness
    numa:              [ false, true ],

    # Context window size - maximum context length for the model
    num_ctx:           Integer,

    # Batch size for processing - number of tokens to process together
    num_batch:         Integer,

    # Number of GPUs to use - specifies how many GPU devices to utilize
    num_gpu:           Integer,

    # Main GPU index - specifies which GPU to use as the primary device
    main_gpu:          Integer,

    # Low VRAM mode - reduces memory usage at the cost of performance
    low_vram:          [ false, true ],

    # Use FP16 for KV cache - enables half-precision floating point for key-value cache
    f16_kv:            [ false, true ],

    # Output all logits - includes all token logits in the output (for debugging)
    logits_all:        [ false, true ],

    # Vocabulary only mode - only loads vocabulary without weights
    vocab_only:        [ false, true ],

    # Use memory mapping - enables memory mapping for model loading
    use_mmap:          [ false, true ],

    # Use memory locking - locks model in memory to prevent swapping
    use_mlock:         [ false, true ],

    # Number of threads to use - specifies CPU thread count for computation
    num_thread:        Integer,

    # Number of tokens to keep - keeps the first N tokens from the context
    num_keep:          Integer,

    # Random seed for reproducible results - sets the random seed for generation
    seed:              Integer,

    # Maximum number of tokens to predict - limits generation length
    num_predict:       Integer,

    # Top-K sampling - limits sampling to top K tokens
    top_k:             Integer,

    # Top-P (nucleus) sampling - limits sampling to tokens that sum to P probability
    top_p:             Float,

    # Minimum probability for token sampling - sets minimum token probability threshold
    min_p:             Float,

    # Tail Free Sampling - controls the tail free sampling parameter
    tfs_z:             Float,

    # Typical P sampling - controls the typical P sampling parameter
    typical_p:         Float,

    # Repeat last N tokens - prevents repetition of last N tokens
    repeat_last_n:     Integer,

    # Temperature - controls randomness in generation (0.0 = deterministic, 1.0 = default)
    temperature:       Float,

    # Repeat penalty - penalizes repeated tokens (higher values = more diversity)
    repeat_penalty:    Float,

    # Presence penalty - penalizes tokens that appear in the context
    presence_penalty:  Float,

    # Frequency penalty - penalizes tokens based on their frequency in the context
    frequency_penalty: Float,

    # Mirostat sampling - controls the Mirostat sampling algorithm (0 = disabled)
    mirostat:          Integer,

    # Mirostat tau parameter - controls the target entropy for Mirostat
    mirostat_tau:      Float,

    # Mirostat eta parameter - controls the learning rate for Mirostat
    mirostat_eta:      Float,

    # Penalize newline tokens - whether to penalize newline tokens
    penalize_newline:  [ false, true ],

    # Stop sequences - array of strings that will stop generation
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

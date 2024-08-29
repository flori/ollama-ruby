module Ollama::Documents::Splitters
  class Semantic
    include Ollama::Utils::Math

    DEFAULT_SEPARATOR = /[.!?]\s*(?:\b|\z)/

    def initialize(ollama:, model:, model_options: nil, separator: DEFAULT_SEPARATOR, chunk_size: 4096)
      @ollama, @model, @model_options, @separator, @chunk_size =
        ollama, model, model_options, separator, chunk_size
    end

    def split(text, batch_size: 100, breakpoint: :percentile, **opts)
      sentences  = Ollama::Documents::Splitters::Character.new(
        separator: @separator,
        include_separator: true,
        chunk_size: 1,
      ).split(text)
      embeddings = sentences.with_infobar(label: 'Split').each_slice(batch_size).inject([]) do |e, batch|
        e.concat sentence_embeddings(batch)
        infobar.progress by: batch.size
        e
      end
      infobar.newline
      distances = embeddings.each_cons(2).map do |a, b|
        1.0 - cosine_similarity(a:, b:)
      end
      max_distance = calculate_breakpoint_threshold(breakpoint, distances, **opts)
      gaps = distances.each_with_index.select do |d, i|
        d > max_distance
      end.transpose.last
      gaps or return sentences
      if gaps.last < distances.size
        gaps << distances.size
      end
      if gaps.last < sentences.size - 1
        gaps << sentences.size - 1
      end
      result = []
      sg = 0
      current_text = +''
      gaps.each do |g|
        sg.upto(g) do |i|
          sentence = sentences[i]
          if current_text.size + sentence.size < @chunk_size
            current_text += sentence
          else
            current_text.empty? or result << current_text
            current_text = sentence
          end
        end
        unless current_text.empty?
          result << current_text
          current_text = +''
        end
        sg = g.succ
      end
      current_text.empty? or result << current_text
      result
    end

    private

    def calculate_breakpoint_threshold(breakpoint_method, distances, **opts)
      sequence = MoreMath::Sequence.new(distances)
      case breakpoint_method
      when :percentile
        percentile = opts.fetch(:percentile, 95)
        sequence.percentile(percentile)
      when :standard_deviation
        percentage = opts.fetch(:percentage, 100)
        (
          sequence.mean + sequence.standard_deviation * (percentage / 100.0)
        ).clamp(0, sequence.max)
      when :interquartile
        percentage = opts.fetch(:percentage, 100)
        iqr = sequence.interquartile_range
        max = sequence.max
        (sequence.mean + iqr * (percentage / 100.0)).clamp(0, max)
      else
        raise ArgumentError, "invalid breakpoint method #{breakpoint_method}"
      end
    end

    def sentence_embeddings(input)
      @ollama.embed(model: @model, input:, options: @model_options).embeddings.map! {
        Numo::NArray[*_1]
      }
    end
  end
end

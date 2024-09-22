module Ollama::Documents::Splitters
  class Character
    DEFAULT_SEPARATOR = /(?:\r?\n){2,}/

    def initialize(separator: DEFAULT_SEPARATOR, include_separator: false, combining_string: "\n\n", chunk_size: 4096)
      @separator, @include_separator, @combining_string, @chunk_size =
        separator, include_separator, combining_string, chunk_size
      if include_separator
        @separator = Regexp.new("(#@separator)")
      end
    end

    def split(text)
      texts = []
      text.split(@separator) do |t|
        if @include_separator && t =~ @separator
          texts.last&.concat t
        else
          texts.push(t)
        end
      end
      result = []
      current_text = +''
      texts.each do |t|
        if current_text.size + t.size < @chunk_size
          current_text << t << @combining_string
        else
          current_text.empty? or result << current_text
          current_text = t
        end
      end
      current_text.empty? or result << current_text
      result
    end
  end

  class RecursiveCharacter
    DEFAULT_SEPARATORS = [
      /(?:\r?\n){2,}/,
      /\r?\n/,
      /\b/,
      //,
    ].freeze

    def initialize(separators: DEFAULT_SEPARATORS, include_separator: false, combining_string: "\n\n", chunk_size: 4096)
      separators.empty? and
        raise ArgumentError, "non-empty array of separators required"
      @separators, @include_separator, @combining_string, @chunk_size =
        separators, include_separator, combining_string, chunk_size
    end

    def split(text, separators: @separators)
      separators.empty? and return [ text ]
      separators = separators.dup
      separator = separators.shift
      texts = Character.new(
        separator:,
        include_separator: @include_separator,
        combining_string: @combining_string,
        chunk_size: @chunk_size
      ).split(text)
      texts.count == 0 and return [ text ]
      texts.inject([]) do |r, t|
        if t.size > @chunk_size
          r.concat(split(t, separators:))
        else
          r.concat([ t ])
        end
      end
    end
  end
end

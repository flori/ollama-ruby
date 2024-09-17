class Ollama::Utils::ColorizeTexts
  include Math
  include Term::ANSIColor
  include Ollama::Utils::Width

  # Initializes a new instance of Ollama::Utils::ColorizeTexts
  #
  # @param [Array<String>] texts the array of strings to be displayed with colors
  #
  # @return [Ollama::Utils::ColorizeTexts] an instance of Ollama::Utils::ColorizeTexts
  def initialize(*texts)
    texts  = texts.map(&:to_a)
    @texts = Array(texts.flatten)
  end

  # Returns a string representation of the object, including all texts content,
  # colored differently and their sizes.
  #
  # @return [String] The formatted string.
  def to_s
    result = +''
    @texts.each_with_index do |t, i|
      color = colors[(t.hash ^ i.hash) % colors.size]
      wrap(t, percentage: 90).each_line { |l|
        result << on_color(color) { color(text_color(color)) { l } }
      }
      result << "\n##{bold{t.size.to_s}} \n\n"
    end
    result
  end

  private

  # Returns the nearest RGB color to the given ANSI color
  #
  # @param [color] color The ANSI color attribute
  #
  # @return [Array<RGBTriple>] An array containing two RGB colors, one for black and
  #   one for white text, where the first is the closest match to the input color
  #   when printed on a black background, and the second is the closest match
  #   when printed on a white background.
  def text_color(color)
    color = Term::ANSIColor::Attribute[color]
    [
      Attribute.nearest_rgb_color('#000'),
      Attribute.nearest_rgb_color('#fff'),
    ].max_by { |t| t.distance_to(color) }
  end

  # Returns an array of colors for each step in the gradient
  #
  # @return [Array<Array<Integer>>] An array of RGB color arrays
  def colors
    @colors ||= (0..255).map { |i|
      [
        128 + 128 * sin(PI * i / 32.0),
        128 + 128 * sin(PI * i / 64.0),
        128 + 128 * sin(PI * i / 128.0),
      ].map { _1.clamp(0, 255).round }
    }
  end
end

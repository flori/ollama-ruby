class Ollama::Utils::ColorizeTexts
  include Math
  include Term::ANSIColor
  include Ollama::Utils::Width

  def initialize(*texts)
    texts = texts.map(&:to_a)
    @texts = Array(texts.flatten)
  end

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

  def text_color(color)
    color = Term::ANSIColor::Attribute[color]
    [
      Attribute.nearest_rgb_color('#000'),
      Attribute.nearest_rgb_color('#fff'),
    ].max_by { |t| t.distance_to(color) }
  end

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

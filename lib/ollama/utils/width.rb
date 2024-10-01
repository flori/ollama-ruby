require 'tins/terminal'

module Ollama::Utils::Width
  include Term::ANSIColor
  extend Term::ANSIColor

  module_function

  def width(percentage: 100.0)
    ((Float(percentage) * Tins::Terminal.columns) / 100).floor
  end

  def wrap(text, percentage: nil, length: nil)
    percentage.nil? ^ length.nil? or
      raise ArgumentError, "either pass percentage or length argument"
    percentage and length ||= width(percentage:)
    text.gsub(/(?<!\n)\n(?!\n)/, ' ').lines.map do |line|
      if length >= 1 && uncolor { line }.length > length
        line.gsub(/(.{1,#{length}})(\s+|$)/, "\\1\n").strip
      else
        line.strip
      end
    end * ?\n
  end

  def truncate(text, percentage: nil, length: nil, ellipsis: ?…)
    percentage.nil? ^ length.nil? or
      raise ArgumentError, "either pass percentage or length argument"
    percentage and length ||= width(percentage:)
    ellipsis_length = ellipsis.size
    if length < ellipsis_length
      +''
    elsif text.size >= length + ellipsis_length
      text[0, length - ellipsis_length] + ellipsis
    else
      text
    end
  end
end

require 'amatch'
require 'search_ui'

module Ollama::Utils::Chooser
  include SearchUI

  module_function

  def choose(entries)
    entry = Search.new(
      match: -> answer {
        matcher = Amatch::PairDistance.new(answer.downcase)
        matches = entries.map { |n| [ n, -matcher.similar(n.to_s.downcase) ] }.
          select { |_, s| s < 0 }.sort_by(&:last).map(&:first)
        matches.empty? and matches = entries
        matches.first(Tins::Terminal.lines - 1)
      },
      query: -> _answer, matches, selector {
        matches.each_with_index.map { |m, i|
          i == selector ? "#{Term::ANSIColor.blue{?⮕}} #{m.on_blue}" : "  #{m}"
        } * ?\n
      },
      found: -> _answer, matches, selector {
        matches[selector]
      },
      output: STDOUT
    ).start
    return entry if entry
  end
end

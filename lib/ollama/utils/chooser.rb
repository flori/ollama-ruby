require 'amatch'
require 'search_ui'
require 'term/ansicolor'

module Ollama::Utils::Chooser
  include SearchUI
  include Term::ANSIColor

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
          i == selector ? "#{blue{?⮕}} #{on_blue{m}}" : "  #{m}"
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

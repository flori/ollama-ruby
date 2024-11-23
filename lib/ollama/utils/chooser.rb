require 'amatch'
require 'search_ui'
require 'term/ansicolor'

module Ollama::Utils::Chooser
  include SearchUI
  include Term::ANSIColor

  module_function

  # The choose method presents a list of entries and prompts the user
  # for input, allowing them to select one entry based on their input.
  #
  # @param entries [Array] the list of entries to present to the user
  # @param prompt [String] the prompt message to display when asking for input (default: 'Search? %s')
  # @param return_immediately [Boolean] whether to immediately return the first entry if there is only one or nil when there is none (default: false)
  #
  # @return [Object] the selected entry, or nil if no entry was chosen
  #
  # @example
  #   choose(['entry1', 'entry2'], prompt: 'Choose an option:')
  def choose(entries, prompt: 'Search? %s', return_immediately: false)
    if return_immediately && entries.size <= 1
      return entries.first
    end
    entry = Search.new(
      prompt:,
      match: -> answer {
        matcher = Amatch::PairDistance.new(answer.downcase)
        matches = entries.map { |n| [ n, -matcher.similar(n.to_s.downcase) ] }.
          select { |_, s| s < 0 }.sort_by(&:last).map(&:first)
        matches.empty? and matches = entries
        matches.first(Tins::Terminal.lines - 1)
      },
      query: -> _answer, matches, selector {
        matches.each_with_index.map { |m, i|
          i == selector ? "#{blue{?⮕}} #{on_blue{m}}" : "  #{m.to_s}"
        } * ?\n
      },
      found: -> _answer, matches, selector {
        matches[selector]
      },
      output: STDOUT
    ).start
    if entry
      entry
    else
      print clear_screen, move_home
      nil
    end
  end
end

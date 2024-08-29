require 'sorted_set'

class Ollama::Utils::Tags < SortedSet
  def to_s
    map { |t| '#%s' % t } * ' '
  end
end

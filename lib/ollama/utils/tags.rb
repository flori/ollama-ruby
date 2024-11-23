class Ollama::Utils::Tags
  class Tag < String
    include Term::ANSIColor

    def initialize(tag, source: nil)
      super(tag.to_s.gsub(/\A#+/, ''))
      self.source = source
    end

    attr_accessor :source

    alias_method :internal, :to_s

    def to_s(link: true)
      tag_string = start_with?(?#) ? super() : ?# + super()
      my_source  = source
      if link && my_source
        unless my_source =~ %r(\A(https?|file)://)
          my_source = 'file://%s' % File.expand_path(my_source)
        end
        hyperlink(my_source) { tag_string }
      else
        tag_string
      end
    end
  end

  def initialize(tags = [], source: nil)
    tags = Array(tags)
    @set = []
    tags.each { |tag| add(tag, source:) }
  end

  def add(tag, source: nil)
    unless tag.is_a?(Tag)
      tag = Tag.new(tag, source:)
    end
    index = @set.bsearch_index { _1 >= tag }
    if index == nil
      @set.push(tag)
    elsif @set.at(index) != tag
      @set.insert(index, tag)
    end
    self
  end

  def empty?
    @set.empty?
  end

  def size
    @set.size
  end

  def clear
    @set.clear
  end

  def each(&block)
    @set.each(&block)
  end
  include Enumerable

  def to_s(link: true)
    @set.map { |tag| tag.to_s(link:) } * ' '
  end
end

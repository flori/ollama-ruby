require 'kramdown'
require 'kramdown-parser-gfm'
require 'terminal-table'

class Ollama::Utils::ANSIMarkdown < Kramdown::Converter::Base
  include Term::ANSIColor
  include Ollama::Utils::Width

  class ::Kramdown::Parser::Mygfm <  ::Kramdown::Parser::GFM
    def initialize(source, options)
      options[:gfm_quirks] << :no_auto_typographic
      super
      @block_parsers -= %i[
        definition_list block_html block_math
        footnote_definition abbrev_definition
      ]
      @span_parsers -= %i[ footnote_marker inline_math ]
    end
  end

  def self.parse(source)
    @doc = Kramdown::Document.new(
      source, input: :mygfm, auto_ids: false, entity_output: :as_char
    ).to_ansi
  end

  def initialize(root, options)
    super
  end

  def convert(el, opts = {})
    send("convert_#{el.type}", el, opts)
  end

  def inner(el, opts, &block)
    result = +''
    options = opts.dup.merge(parent: el)
    el.children.each_with_index do |inner_el, index|
      options[:index] = index
      options[:result] = result
      begin
        content = send("convert_#{inner_el.type}", inner_el, options)
        result << (block&.(inner_el, index, content) || content)
      rescue NameError => e
        warning "Caught #{e.class} for #{inner_el.type}"
      end
    end
    result
  end

  def convert_root(el, opts)
    inner(el, opts)
  end

  def convert_blank(_el, opts)
    opts[:result] =~ /\n\n\Z|\A\Z/ ? "" : "\n"
  end

  def convert_text(el, _opts)
    el.value
  end

  def convert_header(el, opts)
    newline bold { underline { inner(el, opts) } }
  end

  def convert_p(el, opts)
    length = width(percentage: 90) - opts[:list_indent].to_i
    length < 0 and return ''
    newline wrap(inner(el, opts), length:)
  end

  def convert_strong(el, opts)
    bold { inner(el, opts) }
  end

  def convert_em(el, opts)
    italic { inner(el, opts) }
  end

  def convert_a(el, opts)
    url = el.attr['href']
    hyperlink(url) { inner(el, opts) }
  end

  def convert_codespan(el, _opts)
    blue { el.value }
  end

  def convert_codeblock(el, _opts)
    blue { el.value }
  end

  def convert_blockquote(el, opts)
    newline ?“ + inner(el, opts).sub(/\n+\z/, '') + ?”
  end

  def convert_hr(_el, _opts)
    newline ?─ * width(percentage: 100)
  end

  def convert_img(el, _opts)
    url = el.attr['src']
    alt = el.attr['alt']
    alt.strip.size == 0 and alt = url
    alt = '🖼 ' + alt
    hyperlink(url) { alt }
  end

  def convert_ul(el, opts)
    list_indent = opts[:list_indent].to_i
    inner(el, opts) { |_inner_el, index, content|
      result = '· %s' % content
      result = newline(result, count: index <= el.children.size - 1 ? 1 : 2)
      result.gsub(/^/, ' ' * list_indent)
    }
  end

  def convert_ol(el, opts)
    list_indent = opts[:list_indent].to_i
    inner(el, opts) { |_inner_el, index, content|
      result = '%u. %s' % [ index + 1, content ]
      result = newline(result, count: index <= el.children.size - 1 ? 1 : 2)
      result.gsub(/^/, ' ' * list_indent)
    }
  end

  def convert_li(el, opts)
    opts = opts.dup
    opts[:list_indent] = 2 + opts[:list_indent].to_i
    newline inner(el, opts).sub(/\n+\Z/, '')
  end

  def convert_html_element(el, opts)
    if el.value == 'i' || el.value == 'em'
      italic { inner(el, opts) }
    elsif el.value == 'b' || el.value == 'strong'
      bold { inner(el, opts) }
    else
      ''
    end
  end

  def convert_table(el, opts)
    table = Terminal::Table.new
    table.style = {
      all_separators: true,
      border: :unicode_round,
    }
    opts[:table] = table
    inner(el, opts)
    el.options[:alignment].each_with_index do |a, i|
      a == :default and next
      opts[:table].align_column(i, a)
    end
    newline table.to_s
  end

  def convert_thead(el, opts)
    rows = inner(el, opts)
    rows = rows.split(/\s*\|\s*/)[1..].map(&:strip)
    opts[:table].headings = rows
    ''
  end

  def convert_tbody(el, opts)
    res = +''
    res << inner(el, opts)
  end

  def convert_tfoot(el, opts)
    ''
  end

  def convert_tr(el, opts)
    return '' if el.children.empty?
    full_width = width(percentage: 90)
    cols = el.children.map { |c| convert(c, opts).strip }
    row_size = cols.sum(&:size)
    return '' if row_size.zero?
    opts[:table] << cols.map { |c|
      length = (full_width * (c.size / row_size.to_f)).floor
      wrap(c, length:)
    }
    ''
  end

  def convert_td(el, opts)
    inner(el, opts)
  end

  def convert_entity(el, _opts)
    el.value.char
  end

  def convert_xml_comment(*)
    ''
  end

  def convert_xml_pi(*)
    ''
  end

  def convert_br(_el, opts)
    ''
  end

  def convert_smart_quote(el, _opts)
    el.value.to_s =~ /[rl]dquo/ ? "\"" : "'"
  end

  def newline(text, count: 1)
    text.gsub(/\n*\z/, ?\n * count)
  end
end

Kramdown::Converter.const_set(:Ansi, Ollama::Utils::ANSIMarkdown)

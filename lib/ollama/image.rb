require 'base64'

class Ollama::Image
  def initialize(data)
    @data = data
  end

  attr_accessor :path

  class << self
    def for_base64(data, path: nil)
      obj = new(data)
      obj.path = path
      obj
    end

    def for_string(string, path: nil)
      for_base64(Base64.encode64(string), path:)
    end

    def for_io(io, path: nil)
      path ||= io.path
      for_string(io.read, path:)
    end

    def for_filename(path)
      File.open(path, 'rb') { |io| for_io(io, path:) }
    end

    private :new
  end

  def ==(other)
    @data == other..data
  end

  def to_s
    @data
  end
end

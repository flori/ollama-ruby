require 'base64'

class Ollama::Image
  def initialize(data)
    @data = data
  end

  class << self
    def for_base64(data)
      new(data)
    end

    def for_string(string)
      for_base64(Base64.encode64(string))
    end

    def for_io(io)
      for_string(io.read)
    end

    def for_filename(path)
      File.open(path, 'rb') { |io| for_io(io) }
    end

    private :new
  end

  def to_s
    @data
  end
end

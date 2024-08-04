module Ollama
  module Errors
    class Error < StandardError
    end

    class NotFoundError < Error
    end

    class TimeoutError < Error
    end

    class SocketError < Error
    end
  end
end

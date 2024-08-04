require 'infobar'

class Ollama::Handlers::Progress
  include Ollama::Handlers::Concern
  include Term::ANSIColor

  def initialize(output: $stdout)
    super
    @current     = 0
    @total       = nil
    @last_status = nil
  end

  def call(response)
    infobar.display.output = @output
    status = response.status
    if response.total && response.completed
      if !@last_status or @last_status != status
        @last_status and infobar.newline
        @last_status = status
        @current = 0
        @total = response.total
        infobar.counter.reset(total: @total, current: @current)
      end
      infobar.counter.progress(by: response.completed - @current)
      @current = response.completed
    end
    if status
      infobar.label = status
      infobar.update(message: '%l %c/%t in %te, ETA %e @%E', force: true)
    elsif error = response.error
      infobar.puts bold { "Error: " } + red { error }
    end
    self
  end
end

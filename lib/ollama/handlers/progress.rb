require 'infobar'
require 'tins/unit'

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
    if status = response.status
      infobar.label = status
    end
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
      infobar.update(
        message: message(response.completed, response.total),
        force: true
      )
    end
    if error = response.error
      infobar.puts bold { "Error: " } + red { error }
    end
    self
  end

  private

  def message(current, total)
    progress = '%s/%s' % [ current, total ].map {
      Tins::Unit.format(_1, format: '%.2f %U')
    }
    '%l ' + progress + ' in %te, ETA %e @%E'
  end
end

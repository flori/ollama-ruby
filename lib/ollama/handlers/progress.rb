require 'infobar'
require 'tins/unit'

# A handler that displays progress information for streaming operations.
#
# This class is designed to provide visual feedback during long-running
# operations such as model creation, pulling, or pushing. It uses a progress
# bar to show the current status and estimated time remaining, making it easier
# to monitor the progress of these operations in terminal environments.
#
# @example Displaying progress for a model creation operation
#   ollama.create(model: 'my-model', stream: true, &Progress)
class Ollama::Handlers::Progress
  include Ollama::Handlers::Concern
  include Term::ANSIColor

  # The initialize method sets up a new handler instance with the specified
  # output destination and initializes internal state for progress tracking.
  #
  # @param output [ IO ] the output stream to be used for handling responses, defaults to $stdout
  def initialize(output: $stdout)
    super
    @current     = 0
    @total       = nil
    @last_status = nil
  end

  # The call method processes a response by updating progress information and
  # displaying status updates.
  #
  # This method handles the display of progress information for streaming
  # operations by updating the progress bar with current completion status,
  # handling status changes, and displaying any error messages that occur
  # during the operation. It manages internal state to track progress and
  # ensures proper formatting of output.
  #
  # @param response [ Ollama::Response ] the response object containing
  # progress information
  #
  # @return [ self ] returns the handler instance itself after processing the
  # response
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

  # The message method formats progress information into a descriptive string.
  #
  # This method takes current and total values and creates a formatted progress
  # message that includes the current value, total value, time elapsed,
  # estimated time remaining, and the current rate of progress.
  #
  # @param current [ Integer ] the current progress value
  # @param total [ Integer ] the total progress value
  #
  # @return [ String ] a formatted progress message containing current status,
  #         time information, and estimated completion details
  def message(current, total)
    progress = '%s/%s' % [ current, total ].map {
      Tins::Unit.format(_1, format: '%.2f %U')
    }
    '%l ' + progress + ' in %te, ETA %e @%E'
  end
end

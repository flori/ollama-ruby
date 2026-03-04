require 'gem_hadar/simplecov'
GemHadar::SimpleCov.start
require 'rspec'
require 'tins/xt/expose'
begin
  require 'debug'
rescue LoadError
end
require 'webmock/rspec'
WebMock.disable_net_connect!
require 'ollama'

def asset(name)
  File.join(__dir__, 'assets', name)
end

# A module that provides functionality for protecting environment variables
# during tests.
#
# This module ensures that environment variable changes made during test
# execution are automatically restored to their original values after the test
# completes. It is designed to prevent side effects between tests that modify
# environment variables, maintaining a clean testing environment.
module ProtectEnvVars
  # The apply method creates a lambda that protects environment variables
  # during test execution.
  #
  # @return [Proc] a lambda that wraps test execution with environment variable
  #   preservation
  def self.apply
    -> example do
      if example.metadata[:protect_env]
        begin
          stored_env = ENV.to_h
          example.run
        ensure
          ENV.replace(stored_env)
        end
      else
        example.run
      end
    end
  end
end

RSpec.configure do |config|
  config.around(&ProtectEnvVars.apply)

  config.before(:suite) do
    infobar.show = nil
  end
end

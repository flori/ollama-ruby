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

RSpec.configure do |config|
  config.before(:suite) do
    infobar.show = nil
  end
end

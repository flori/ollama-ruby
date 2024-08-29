if ENV['START_SIMPLECOV'].to_i == 1
  require 'simplecov'
  SimpleCov.start do
    add_filter "#{File.basename(File.dirname(__FILE__))}/"
  end
end
require 'rspec'
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

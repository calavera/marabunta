require 'rubygems'
begin
  require 'spec'
rescue LoadError
  gem 'rspec'
  require 'rspec'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'marabunta'
require 'mocha'

Rspec.configure do |config|
  config.mock_with :mocha
end

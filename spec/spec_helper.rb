require 'rubygems'
begin
  require 'spec'
rescue LoadError
  gem 'rspec'
  require 'spec'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'marabunta/marabunta'
require 'mocha'

Spec::Runner.configure do |config|
  config.mock_with :mocha
end

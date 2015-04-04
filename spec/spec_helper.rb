require 'rubygems'

require 'simplecov'
require 'coveralls'
SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter 'spec'
end

require 'rspec'
require File.dirname(__FILE__) + '/../lib/gov_kit-ca'

RSpec.configure do |config|
  config.filter_run_excluding :broken => true
end

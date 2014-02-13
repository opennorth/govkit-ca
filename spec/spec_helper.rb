require 'rubygems'

require 'coveralls'
Coveralls.wear!

require 'rspec'
require File.dirname(__FILE__) + '/../lib/gov_kit-ca'

module Helpers
  def fixture_path(*args)
    File.join(File.dirname(__FILE__), 'fixtures', *args)
  end
end

RSpec.configure do |config|
  config.include Helpers
  config.filter_run_excluding broken: true
end

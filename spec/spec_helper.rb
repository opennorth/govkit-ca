require 'rubygems'

require 'coveralls'
Coveralls.wear!

require 'rspec'
require 'fakeweb'
require File.dirname(__FILE__) + '/../lib/gov_kit-ca'

FakeWeb.allow_net_connect = true

module Helpers
  def fixture_path(*args)
    File.join(File.dirname(__FILE__), 'fixtures', *args)
  end
end

RSpec.configure do |config|
  config.include Helpers
  config.filter_run_excluding broken: true
end

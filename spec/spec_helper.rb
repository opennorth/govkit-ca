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

EXPECTATIONS = {
  conservative_ca: {
    'T1P1K1' => [48010],
    'K0A1K0' => [35025, 35052, 35063],
  },
  elections_ca: {
    'G0C2Y0' => [24026],
    'T5S2B9' => [48031],
  },
  green_party_ca: {
    'G0C2Y0' => [24026],
    'T5S2B9' => [48031],
  },
  liberal_ca: {
    'G0C2Y0' => [24026],
    'T5S2B9' => [48031],
    'B0J2L0' => [12002], # too few
    'K0A1K0' => [35076], # too few
  },
  ndp_ca: {
    'G0C2Y0' => [24026],
    'T5S2B9' => [48031],
    'B0J2L0' => [12002, 12008],
    'K0A1K0' => [35031, 35076],
  },

  # Deprecated.
  cbc_ca: {
    'G0C2Y0' => [24019],
    'T5S2B9' => [48015, 48017],
    'B0J2L0' => [12002, 12007, 12008],
    'K0A1K0' => [35025, 35052, 35063, 35064],
  },
  digital_copyright_ca: {
    'G0C2Y0' => [24019, 24039],
    'T5S2B9' => [48012, 48013, 48014, 48015, 48017, 48018],
    'B0J2L0' => [12002, 12007, 12008],
    'K0A1K0' => [35025, 35052, 35063],
  },
}

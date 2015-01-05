require 'erb'
require 'json'
require 'yaml'

require 'faraday'
require 'httparty'
require 'nokogiri'

module GovKit
  module CA
    class GovKitError < StandardError; end
    class ResourceNotFound < GovKitError; end
    class InvalidRequest < GovKitError; end
  end
end

require 'gov_kit-ca/postal_code'
require 'gov_kit-ca/postal_code/strategy_set'
require 'gov_kit-ca/postal_code/strategy/base'
require 'gov_kit-ca/postal_code/strategy/cbc_ca'
require 'gov_kit-ca/postal_code/strategy/conservative_ca'
require 'gov_kit-ca/postal_code/strategy/digital-copyright_ca'
require 'gov_kit-ca/postal_code/strategy/elections_ca'
require 'gov_kit-ca/postal_code/strategy/greenparty_ca'
require 'gov_kit-ca/postal_code/strategy/liberal_ca'
require 'gov_kit-ca/postal_code/strategy/ndp_ca'
require 'gov_kit-ca/postal_code/strategy/parl_gc_ca'
require 'gov_kit-ca/represent'

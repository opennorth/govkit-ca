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

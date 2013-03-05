require 'erb'
require 'json'
require 'yaml'

require 'httparty'
require 'nokogiri'
require 'yajl'

module GovKit
  module CA
    class GovKitError < StandardError; end
    class ResourceNotFound < GovKitError; end
    class InvalidRequest < GovKitError; end
  end
end

require 'gov_kit-ca/postal_code'

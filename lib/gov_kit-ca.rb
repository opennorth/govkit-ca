require 'erb'
require 'json'
require 'yaml'

require 'httparty'
require 'nokogiri'
require 'yajl'

module GovKit
  module CA
    autoload :PostalCode, 'gov_kit-ca/postal_code'

    class GovKitError < StandardError; end
    class ResourceNotFound < GovKitError; end
    class InvalidRequest < GovKitError; end
  end
end

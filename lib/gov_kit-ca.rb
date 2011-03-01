$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__))) unless $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)))

require 'uri'
require 'json'

require 'httparty'
require 'nokogiri'
require 'yajl'

module GovKit
  module CA
    autoload :PostalCode, 'gov_kit-ca/postal_code'

    class GovKitError < StandardError; end
    class ResourceNotFound < GovKitError; end
  end
end

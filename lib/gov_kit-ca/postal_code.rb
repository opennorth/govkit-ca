require 'gov_kit-ca/postal_code/strategy'

module GovKit
  module CA
    # A collection of postal code helpers.
    # @see http://en.wikipedia.org/wiki/Postal_codes_in_Canada Postal codes in Canada
    module PostalCode
      # Returns the electoral districts within a postal code.
      #
      # Statistics Canada charges for its Postal Codes by Federal Ridings File
      # (PCFRF). A free alternative requires scraping data from other sources.
      #
      # @param [String] postal_code a postal code
      # @return [Array<Fixnum>] the electoral districts within the postal code
      # @raise [ResourceNotFound] if the electoral districts cannot be determined
      # @see http://www.statcan.gc.ca/bsolc/olc-cel/olc-cel?lang=eng&catno=92F0193X Statistics Canada's product page for the Postal Codes by Federal Ridings File (PCFRF)
      def self.find_electoral_districts_by_postal_code(postal_code)
        StrategySet.run format_postal_code(postal_code)
      end

      # Returns the province that a postal code belongs to.
      # @param [String] postal_code a postal code
      # @return [String] the province that the postal code belongs to
      # @raise [ResourceNotFound] if the province cannot be determined
      # @see http://en.wikipedia.org/wiki/List_of_postal_codes_in_Canada List of postal codes in Canada
      def self.find_province_by_postal_code(postal_code)
        case format_postal_code(postal_code)
        when /\AA/
          'Newfoundland and Labrador'
        when /\AB/
          'Nova Scotia'
        when /\AC/
          'Prince Edward Island'
        when /\AE/
          'New Brunswick'
        when /\A[GHJ]/
          'Quebec'
        when /\A[KLMNP]/
          'Ontario'
        when /\AR/
          'Manitoba'
        when /\AS/
          'Saskatchewan'
        when /\AT/
          'Alberta'
        when /\AV/
          'British Columbia'
        # http://en.wikipedia.org/wiki/List_of_X_postal_codes_of_Canada
        when /\AX0[ABC]/
          'Nunavut'
        when /\AX0[EG]/, /\AX1A/
          'Northwest Territories'
        when /\AY/
          'Yukon'
        else
          raise ResourceNotFound, "The province cannot be determined from the postal code"
        end
      end

      # Formats a postal code as A1A1A1. Removes non-alphanumeric characters.
      # @param [String] postal_code a postal code
      # @return [String] a formatted postal code
      def self.format_postal_code(postal_code)
        postal_code.upcase.gsub(/[^A-Z0-9]/, '')
      end
    end
  end
end

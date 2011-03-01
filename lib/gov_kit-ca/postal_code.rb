require 'gov_kit-ca/postal_code/strategy'

module GovKit
  module CA
    # Statistics Canada charges for its Postal Codes by Federal Ridings File
    # (PCFRF). A free alternative requires scraping data from other sources.
    # The most reliable sources are elections.ca and digital-copyright.ca.
    #
    # ## Alternatives (2011-02-28)
    #
    # ### Scrapers
    #
    # https://github.com/danielharan/postal_code_to_edid_webservice queries
    # elections.ca, but it caches the results forever, which is inappropriate
    # because postal codes and electoral districts change.
    #
    # https://github.com/danielharan/pc_scraper queries cbc.ca.
    # 
    # https://github.com/danielharan/canadian-postal-code-to-electoral-districts
    # is a YAML file mapping postal codes to electoral districts. Postal codes
    # and electoral districts change, however, so it is not a reliable mapping.
    #
    # http://www.digital-copyright.ca/pcfrf/pcfrf.tgz contains
    # `postal-code-for-districts.csv`, "which is 308 postal codes that should
    # map to each of the 308 different electoral districts." However, six of the
    # postal codes are invalid (G0A2C0, J8M1R8, J0W1B0, J0B1H0, L0J1B0, N2A1A3),
    # 14 are duplicated, and the remaining 294 map to 246 electoral districts.
    #
    # ### Non-partisan web sites
    #
    # http://www2.parl.gc.ca/parlinfo/Compilations/HouseOfCommons/MemberByPostalCode.aspx?PostalCode=B0J2L0
    # returns HTML with electoral district names only.
    #
    # http://www.digital-copyright.ca/edid/postal?postalcode=B0J2L0 returns
    # HTML with links whose `href` attributes contain the electoral districts.
    #
    # http://www.makethechange.ca/ charges more than Statistics Canada. Lame.
    #
    # ### Political party web sites
    #
    # http://www.conservative.ca/?section_id=1051&postal_code=B0J2L0 returns
    # HTML with electoral district names only. In the case of B0J2L0, it does
    # not return three ridings like other sources.
    #
    # http://www.liberal.ca/riding/postal/B0J2L0/ returns HTML with images
    # whose `src` attributes contain the electoral districts.
    #
    # http://www.ndp.ca/riding/B0J2L0 issues a Location header containing the
    # electoral district. It does not handle postal codes containing multiple
    # electoral districts.
    #
    # @see http://en.wikipedia.org/wiki/Postal_codes_in_Canada Postal codes in Canada
    module PostalCode
      # Formats a postal code as A1A1A1. Removes non-alphanumeric characters.
      # @param [String] postal_code a postal code
      # @return [String] a formatted postal code
      def self.format_postal_code(postal_code)
        postal_code.upcase.gsub(/[^A-Z0-9]/)
      end

      # Returns the electoral districts within a postal code.
      # @param [String] postal_code a postal code
      # @return [Array<Fixnum>] the electoral districts within the postal code
      # @raise [ResourceNotFound] if the electoral districts cannot be determined
      # @see http://www.statcan.gc.ca/bsolc/olc-cel/olc-cel?lang=eng&catno=92F0193X Statistics Canada's product page for the Postal Codes by Federal Ridings File (PCFRF)
      def self.find_electoral_districts_by_postal_code(postal_code)
        Strategy
      end

      # Returns the province that a postal code belongs to.
      # @param [String] postal_code a postal code
      # @return [String] the province that the postal code belongs to
      # @raise [ResourceNotFound] if the province cannot be determined
      # @see http://en.wikipedia.org/wiki/List_of_postal_codes_in_Canada List of postal codes in Canada
      def self.find_province_by_postal_code(postal_code)
        case format_postal_code(postal_code)
        when /\AA/: 'Newfoundland and Labrador'
        when /\AB/: 'Nova Scotia'
        when /\AC/: 'Prince Edward Island'
        when /\AE/: 'New Brunswick'
        when /\A[GHJ]/: 'Quebec'
        when /\A[KLMNP]/: 'Ontario'
        when /\AR/: 'Manitoba'
        when /\AS/: 'Saskatchewan'
        when /\AT/: 'Alberta'
        when /\AV/: 'British Columbia'
        # http://en.wikipedia.org/wiki/List_of_X_postal_codes_of_Canada
        when /\AX0[ABC]/: 'Nunavut'
        when /\AX0[EG]/, /\AX1A/: 'Northwest Territories'
        when /\AY/: 'Yukon'
        else raise ResourceNotFound, "The province cannot be determined from the postal code"
        end
      end
    end
  end
end

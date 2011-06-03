module GovKit
  module CA
    module PostalCode
      module Strategy
        # digital-copyright.ca often returns more or fewer electoral districts
        # than others. Occasionally suffers from timeout errors.
        class DigitalCopyrightCa < Base
          base_uri 'www.digital-copyright.ca'

        private

          def electoral_districts!
            Nokogiri::HTML(response.parsed_response).css('.node .content a').map{|a| a[:href][/\d+\Z/]}
          end

          def valid?
            !response.parsed_response.match /\b(invalid postal code|not found)\b/
          end

          def response
            @response ||= self.class.get "/edid/postal?postalcode=#{@postal_code}"
          end
        end

        StrategySet.register DigitalCopyrightCa
      end
    end
  end
end

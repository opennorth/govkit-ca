module GovKit
  module CA
    module PostalCode
      module Strategy
        # Occasionally suffers from timeout errors.
        class DigitalCopyrightCa < Base
          base_uri 'www.digital-copyright.ca'

        private

          def electoral_districts!
            Nokogiri::HTML(response.parsed_response).css('.node .content a').map{|a| a[:href][/\d+\Z/]}
          end

          def valid?
            !response.parsed_response.match /\binvalid postal code\b/
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

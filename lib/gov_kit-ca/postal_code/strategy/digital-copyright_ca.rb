module GovKit
  module CA
    module PostalCode
      module Strategy
        # digital-copyright.ca often returns more or fewer electoral districts
        # than others. It says it uses makethechange.ca, but makethechange.ca
        # returns different results for, e.g., K0A1K0.
        class DigitalCopyrightCa < Base
          base_uri 'www.digital-copyright.ca'
          http_method :get
          path '/edid/postal?postalcode=<%= @postal_code %>'

        private

          def electoral_districts!
            Nokogiri::HTML(response.parsed_response, nil, 'utf-8').css('.node .content a').map{|a| a[:href][/\d+\z/]}
          end

          def valid?
            !response.parsed_response.match /\b(invalid postal code|not found)\b/
          end
        end

        StrategySet.register DigitalCopyrightCa
      end
    end
  end
end

module GovKit
  module CA
    module PostalCode
      module Strategy
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
      end
    end
  end
end

module GovKit
  module CA
    module PostalCode
      module Strategy
        # liberal.ca seems unreliable. It returns three ridings for K0A1K0.
        class LiberalCa < Base
          follow_redirects true
          base_uri 'www.liberal.ca'
          http_method :get
          path '/riding/postal/<%= @postal_code %>/'

        private

          def electoral_districts!
            Nokogiri::HTML(response.parsed_response, nil, 'utf-8').css('img.RidingListImage').map{|img| img[:src][/\d{5}/]}
          end

          def valid?
            !response.parsed_response["Sorry we couldn't find your riding."]
          end
        end

        StrategySet.register LiberalCa
      end
    end
  end
end

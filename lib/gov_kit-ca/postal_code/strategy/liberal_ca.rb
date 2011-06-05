module GovKit
  module CA
    module PostalCode
      module Strategy
        # liberal.ca is unreliable during elections.
        class LiberalCa < Base
          base_uri 'www.liberal.ca'
          http_method :get
          path '/riding/postal/<%= @postal_code %>/'

        private

          def electoral_districts!
            Nokogiri::HTML(response.parsed_response, nil, 'utf-8').css('img.RidingListImage').map{|img| img[:src][/\d{5}/]}
          end

          def valid?
            !response.parsed_response.match /\bOopsies!/
          end
        end

        StrategySet.register LiberalCa
      end
    end
  end
end

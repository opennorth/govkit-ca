module GovKit
  module CA
    module PostalCode
      module Strategy
        # liberal.ca is unreliable during elections.
        class LiberalCa < Base
          base_uri 'www.liberal.ca'

        private

          def electoral_districts!
            Nokogiri::HTML(response.parsed_response).css('img.RidingListImage').map{|img| img[:src][/\d{5}/]}
          end

          def valid?
            !response.parsed_response.match /\bOopsies!/
          end

          def response
            @response ||= self.class.get "/riding/postal/#{@postal_code}/"
          end
        end

        StrategySet.register LiberalCa
      end
    end
  end
end

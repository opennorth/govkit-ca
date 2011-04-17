module GovKit
  module CA
    module PostalCode
      module Strategy
        # greenparty.ca does not return electoral districts for postal codes
        # that contain multiple electoral districts.
        class GreenPartyCa < Base
          base_uri 'greenparty.ca'

        private

          def electoral_districts!
            [ response.headers['location'][/\d+\Z/] ]
          end

          def valid?
            response.headers['location'] != 'http://greenparty.ca/find_your_riding'
          end

          def response
            @response ||= self.class.head "/search/civicrm_lookup/#{@postal_code}"
          end
        end

        StrategySet.register GreenPartyCa
      end
    end
  end
end

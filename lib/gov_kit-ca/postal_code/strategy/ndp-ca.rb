module GovKit
  module CA
    module PostalCode
      module Strategy
        # ndp.ca does not return electoral districts for postal codes that
        # contain multiple electoral districts.
        class NDPCa < Base
          base_uri 'www.ndp.ca'

        private

          def electoral_districts!
            [ response.headers['location'][/\d+\Z/] ]
          end

          def valid?
            response.headers['location'] != 'http://www.ndp.ca/'
          end

          def response
            @response ||= self.class.head "http://www.ndp.ca/riding/#{@postal_code}"
          end
        end

        StrategySet.register NDPCa
      end
    end
  end
end

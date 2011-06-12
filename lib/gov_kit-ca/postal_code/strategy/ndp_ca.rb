module GovKit
  module CA
    module PostalCode
      module Strategy
        # ndp.ca does not return electoral districts for postal codes that
        # contain multiple electoral districts.
        class NDPCa < Base
          base_uri 'www.ndp.ca'
          http_method :head
          path '/riding/<%= @postal_code %>'

        private

          def electoral_districts!
            [ response.headers['location'][/\d+\z/] ]
          end

          def valid?
            response.headers['location'] != 'http://www.ndp.ca/'
          end
        end

        StrategySet.register NDPCa
      end
    end
  end
end

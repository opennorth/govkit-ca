module GovKit
  module CA
    module PostalCode
      module Strategy
        class GreenPartyCa < Base
          base_uri 'www.greenparty.ca'
          http_method :head
          path '/search/green_geo/<%= @postal_code %>'

        private

          def electoral_districts!
            [ response.headers['location'][/\d+\z/] ]
          end

          def valid?
            response.headers['location'] != 'http://www.greenparty.ca/find_your_riding'
          end
        end

        StrategySet.register GreenPartyCa
      end
    end
  end
end

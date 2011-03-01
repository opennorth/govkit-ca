module GovKit
  module CA
    module PostalCode
      module Strategy
        # elections.ca is a reliable source, but it does not return electoral
        # districts for postal codes that contain multiple electoral districts.
        class ElectionsCa < Base
          base_uri 'elections.ca'

        private

          def electoral_districts!
            [ response.headers['location'][/&ED=(\d{5})&/, 1] ]
          end

          def valid?
            !!response.headers['location']
          end

          def response
            @response ||= self.class.head "/scripts/pss/FindED.aspx?PC=#{@postal_code}"
          end
        end

        StrategySet.register ElectionsCa
      end
    end
  end
end

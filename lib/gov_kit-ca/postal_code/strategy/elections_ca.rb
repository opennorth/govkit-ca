module GovKit
  module CA
    module PostalCode
      module Strategy
        # @see https://github.com/danielharan/postal_code_to_edid_webservice
        class ElectionsCa < Base
          base_uri 'elections.ca'
          http_method :head
          path '/scripts/pss/FindED.aspx?PC=<%= @postal_code %>'

        private

          def electoral_districts!
            [ response.headers['location'][/\bED=(\d{5})&/, 1] ]
          end

          def valid?
            !!response.headers['location']
          end
        end

        StrategySet.register ElectionsCa
      end
    end
  end
end

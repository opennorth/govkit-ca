module GovKit
  module CA
    module PostalCode
      module Strategy
        class ParlGcCa < Base
          base_uri 'www.parl.gc.ca'
          http_method :get
          path '/ParlInfo/Compilations/HouseOfCommons/MemberByPostalCode.aspx?PostalCode=<%= @postal_code %>'

        private

          def electoral_districts!
            # TODO returns HTML with electoral district names only
          end

          def valid?
            # TODO
          end
        end

        StrategySet.register ParlGcCa
      end
    end
  end
end

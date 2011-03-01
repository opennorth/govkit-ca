module GovKit
  module CA
    module PostalCode
      module Strategy
        class ParlGcCa < Base
          base_uri 'parl.gc.ca'

        private

          def electoral_districts!
            # TODO returns HTML with electoral district names only
          end

          def valid?
            # TODO
          end

          def response
            @response ||= self.class.get "http://www2.parl.gc.ca/parlinfo/Compilations/HouseOfCommons/MemberByPostalCode.aspx?PostalCode=#{@postal_code}"
          end
        end

        StrategySet.register ParlGcCa
      end
    end
  end
end

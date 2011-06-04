module GovKit
  module CA
    module PostalCode
      module Strategy
        # parl.gc.ca seems unreliable. In the case of K0A1K0, for example, it
        # does not return seven ridings like other sources.
        class ParlGcCa < Base
          base_uri 'www2.parl.gc.ca'

        private

          def electoral_districts!
            # TODO returns HTML with electoral district names only
          end

          def valid?
            # TODO
          end

          def response
            @response ||= self.class.get "/parlinfo/Compilations/HouseOfCommons/MemberByPostalCode.aspx?PostalCode=#{@postal_code}"
          end
        end

        StrategySet.register ParlGcCa
      end
    end
  end
end

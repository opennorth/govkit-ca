module GovKit
  module CA
    module PostalCode
      module Strategy
        class LiberalCa < Base
          base_uri 'www.liberal.ca'

        private

          def electoral_districts!
            # TODO returns HTML with images whose `src` attributes contain the electoral districts.
          end

          def valid?
            # TODO
          end

          def response
            @response ||= self.class.get "http://www.liberal.ca/riding/postal/#{@postal_code}/"
          end
        end

        StrategySet.register LiberalCa
      end
    end
  end
end

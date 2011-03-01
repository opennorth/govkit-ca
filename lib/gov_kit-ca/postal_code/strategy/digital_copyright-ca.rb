module GovKit
  module CA
    module PostalCode
      module Strategy
        class DigitalCopyrightCa < Base
          base_uri 'www.digital-copyright.ca'

        private

          def electoral_districts!
            # TODO returns HTML with links whose `href` attributes contain the electoral districts
          end

          def valid?
            # TODO
          end

          def response
            @response ||= self.class.get "http://www.digital-copyright.ca/edid/postal?postalcode=#{@postal_code}"
          end
        end

        StrategySet.register DigitalCopyrightCa
      end
    end
  end
end

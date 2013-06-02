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
            # @todo returns HTML with electoral district names only
          end

          def valid?
            !!div
          end

          def div
            @div ||= Nokogiri::HTML(response.parsed_response, nil, 'utf-8').at_css('#ctl00_cphContent_pnlWithMP')
          end
        end

        StrategySet.register ParlGcCa
      end
    end
  end
end

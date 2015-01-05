module GovKit
  module CA
    module PostalCode
      module Strategy
        class LiberalCa < Base
          follow_redirects true
          base_uri 'www.liberal.ca'
          http_method :get
          path '/ridings/<%= @postal_code %>/'

        private

          def electoral_districts!
            [response.parsed_response[%r{https://action.liberal.ca/en/donate/riding/(\d{5})}, 1]]
          end

          def valid?
            !response.parsed_response["We couldn't find a riding for that postal code."]
          end
        end
      end
    end
  end
end

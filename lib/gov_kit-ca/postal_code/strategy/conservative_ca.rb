module GovKit
  module CA
    module PostalCode
      module Strategy
        class ConservativeCa < Base
          base_uri 'www.conservative.ca'
          http_method :get
          path '/team/?postalcode=<%= @postal_code %>'

        private

          def electoral_districts!
            # @todo returns HTML with electoral district names only
          end
        end
      end
    end
  end
end

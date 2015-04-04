module GovKit
  module CA
    module PostalCode
      module Strategy
        class GreenPartyCa < Base
          base_uri 'www.greenparty.ca'
          http_method :post
          path '/en/party/find-your-riding'
          post_data 'form_id=gpc_glue_riding_lookup_form&postal_code=<%= @postal_code %>'

        private

          def electoral_districts!
            [response.headers['location'][/\d+\z/]]
          end

          def valid?
            response.headers['location'] != 'http://www.greenparty.ca/en/party/find-your-riding'
          end
        end
      end
    end
  end
end

module GovKit
  module CA
    module PostalCode
      module Strategy
        class NDPCa < Base
          base_uri 'www.ndp.ca'
          http_method :get
          path '/your-riding/?search=<%= @postal_code %>'

        private

          def electoral_districts!
            Nokogiri::HTML(response.parsed_response, nil, 'utf-8').css('a.mp-riding-link,a.no-mp').map{|a| a[:href][/\d+\z/]}
          end

          def valid?
            !response.parsed_response['No ridings or MPs match this search.']
          end
        end
      end
    end
  end
end

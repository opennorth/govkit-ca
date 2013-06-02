module GovKit
  module CA
    module PostalCode
      module Strategy
        class ConservativeCa < Base
          base_uri 'www.conservative.ca'
          http_method :post
          path '/?page_id=35'
          post_data 'findmymp=35&pc=<%= @postal_code %>'

        private

          def electoral_districts!
            images.map{|a| a[:src][/\d+\.jpg\z/]}
          end

          def valid?
            !images.empty?
          end

          def images
            @images ||= Nokogiri::HTML(response.parsed_response, nil, 'utf-8').css('#type img')
          end
        end

        StrategySet.register ConservativeCa
      end
    end
  end
end

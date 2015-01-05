module GovKit
  module CA
    module PostalCode
      module Strategy
        class ConservativeCa < Base
          base_uri 'www.conservative.ca'
          http_method :get
          path '/wp-content/themes/conservative/functions-process.php?x=vldpc&fpc=<%= @postal_code %>'

        private

          def electoral_districts!
            images.map{|a| a[:src][/\d+\.jpg\z/]}
          end

          def valid?
            !images.empty?
          end

          def images
            @images ||= Nokogiri::HTML(response.parsed_response, nil, 'utf-8').css('img')
          end
        end
      end
    end
  end
end

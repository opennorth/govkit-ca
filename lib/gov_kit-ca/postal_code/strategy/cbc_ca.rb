module GovKit
  module CA
    module PostalCode
      module Strategy
        class CBCCa < Base
          base_uri 'www.cbc.ca'
          http_method :get
          path '/news/politics/canadavotes2011/myelection/postalcodes/index.php?pc=<%= @postal_code %>'

        private

          def electoral_districts!
            JSON.load(response.parsed_response).map{|x| self.class.rid_to_edid[x['rid'].to_i]}
          end

          def valid?
            response.code != 404
          end

          # cbc.ca uses an internal riding ID, which must be matched to a
          # canonical electoral district ID.
          # @return [Hash] a map of cbc.ca riding ID to electoral district ID
          def self.rid_to_edid
            @@yml ||= YAML.load_file(File.expand_path('../../../../rid_to_edid.yml', __FILE__))
          end
        end
      end
    end
  end
end

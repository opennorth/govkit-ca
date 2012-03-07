module GovKit
  module CA
    module PostalCode
      module Strategy
        # cbc.ca ought to be a reliable source. It is unknown if its database
        # is kept up-to-date between elections, however.
        # @see https://github.com/danielharan/pc_scraper
        class CBCCa < Base
          base_uri 'www.cbc.ca'
          http_method :get
          path '/news/politics/canadavotes2011/myelection/postalcodes/index.php?pc=<%= @postal_code %>'

        private
          def electoral_districts!
            Yajl::Parser.parse(response.parsed_response).map{|x| self.class.rid_to_edid[x['rid'].to_i]}
          end

          def valid?
            response.code != 404
          end

          # cbc.ca uses an internal riding ID, which must be matched to a
          # canonical electoral district ID.
          # @return [Hash] a map of cbc.ca riding ID to electoral district ID
          def self.rid_to_edid
            @@yml ||= YAML.load_file(File.expand_path('../../../../data/rid_to_edid.yml', __FILE__))
          end
        end

        StrategySet.register CBCCa
      end
    end
  end
end

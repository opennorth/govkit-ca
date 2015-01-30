module GovKit
  module CA
    # A Ruby wrapper for the Represent API.
    # @see https://represent.opennorth.ca/api/
    class Represent
      # @param [Faraday::Connection] connection a Faraday connection
      def initialize(connection = nil)
        @client = connection || Faraday
      end

      # Get boundary sets.
      #
      # @param [Hash] opts optional arguments
      # @option opts [String] :boundary_set a boundary set
      # @option opts [Integer] :limit
      # @option opts [Integer] :offset
      # @see https://represent.opennorth.ca/api/#boundaryset
      def boundary_sets(opts = {})
        request(['boundary-sets', opts.delete(:boundary_set)], opts)
      end

      # Get boundaries.
      #
      # @param [Hash] opts optional arguments
      # @option opts [String] :boundary_set a boundary set
      # @option opts [String] :boundary a boundary
      # @option opts [Boolean] :representatives
      # @option opts [Array<String>,String] :sets comma-separated list of boundary sets
      # @option opts [Array<Float>,String] :contains comma-separated latitude and longitude
      # @option opts [String] :touches a boundary
      # @option opts [String] :intersects a boundary
      # @option opts [Integer] :limit
      # @option opts [Integer] :offset
      # @see https://represent.opennorth.ca/api/#boundary
      def boundaries(opts = {})
        if Array === opts[:sets]
          opts[:sets] = opts[:sets].join(',')
        end
        if Array === opts[:contains]
          opts[:contains] = opts[:contains].join(',')
        end
        if opts.has_key?(:boundary) && !opts.has_key?(:boundary_set)
          raise ArgumentError, ':boundary_set must be set if :boundary is set'
        end
        if opts[:representatives] && !(opts.has_key?(:boundary) && opts.has_key?(:boundary_set))
          raise ArgumentError, ':boundary_set and :boundary must be set if :representatives is true'
        end
        request(['boundaries', opts.delete(:boundary_set), opts.delete(:boundary), opts.delete(:representatives) && 'representatives'], opts)
      end

      # Get boundaries and representatives by postal code.
      #
      # @param [Hash] opts optional arguments
      # @option opts [Array<String>,String] :sets comma-separated list of boundary sets
      # @option opts [Integer] :limit
      # @option opts [Integer] :offset
      # @see https://represent.opennorth.ca/api/#postcode
      def postcodes(postcode, opts = {})
        if Array === opts[:sets]
          opts[:sets] = opts[:sets].join(',')
        end
        request(['postcodes', PostalCode.format_postal_code(postcode)], opts)
      end

      # Get representative sets.
      #
      # @param [Hash] opts optional arguments
      # @option opts [String] :representative_set a representative set
      # @option opts [Integer] :limit
      # @option opts [Integer] :offset
      # @see https://represent.opennorth.ca/api/#representativeset
      def representative_sets(opts = {})
        request ['representative-sets', opts.delete(:representative_set)], opts
      end

      # Get representatives.
      #
      # @param [Hash] opts optional arguments
      # @option opts [String] :representative_set a representative set
      # @option opts [Array<Float>,String] :point a comma-separated latitude and longitude
      # @option opts [Array<Strong>,String] :districts a comma-separated list of boundaries
      # @option opts [Integer] :limit
      # @option opts [Integer] :offset
      # @see https://represent.opennorth.ca/api/#representative
      def representatives(opts = {})
        if Array === opts[:point]
          opts[:point] = opts[:point].join(',')
        end
        if Array === opts[:districts]
          opts[:districts] = opts[:districts].join(',')
        end
        request(['representatives', opts.delete(:representative_set)], opts)
      end

    private

      def request(parts, opts)
        begin
          url = "https://represent.opennorth.ca/#{parts.compact.join('/')}/"
          response = @client.get(url, opts)
          case response.status
          when 200
            JSON.parse(response.body)
          when 404
            raise ResourceNotFound, "#{response.status} #{url}?#{opts.map{|k,v| "#{k}=#{v}"}.join('&')}"
          else
            raise InvalidRequest, "#{response.status} #{url}?#{opts.map{|k,v| "#{k}=#{v}"}.join('&')} #{response.body}"
          end
        end
      end
    end
  end
end

module GovKit
  module CA
    module PostalCode
      module Strategy
        # Abstract class for implementing postal code to electoral district
        # strategies.
        #
        # The following instance methods must be implemented in sub-classes:
        #
        # * `electoral_districts!`
        #
        # The following class methods must be called in sub-classes:
        #
        # * `http_method`
        # * `path`
        class Base
          include HTTParty
          follow_redirects false
          headers 'User-Agent' => 'GovKit-CA +http://govkit.org'

          # Creates a new postal code to electoral district strategy.
          # @param [String] postal_code a postal code
          def initialize(postal_code)
            @postal_code = postal_code
          end

          # Returns the electoral districts within a postal code.
          # @return [Array<Fixnum>] the electoral districts within the postal code
          def electoral_districts
            valid? && electoral_districts!.map(&:to_i).sort
          end

        private

          # Returns the electoral districts within a postal code, without
          # passing validation first.
          # @return [Array<Fixnum>] the electoral districts within the postal code
          def electoral_districts!
            raise NotImplementedError
          end

          # @return [Boolean] whether the electoral districts can be determined
          def valid?
            true
          end

          # Performs the request and returns the response.
          # @return [HTTParty::Response] a HTTParty response object
          def response
            @response ||= begin
              if self.class.http_method == :post
                self.class.post path, :body => post_data
              else
                self.class.send self.class.http_method, path
              end
            end
          end

          # Allows setting an HTTP method to be used for each request.
          # @param [Symbol] http_method an HTTP method
          # @return [Symbol] the HTTP method to use to send the request
          def self.http_method(http_method = nil)
            return default_options[:http_method] unless http_method
            default_options[:http_method] = http_method
          end

          # Allows setting an absolute path to be used in each request.
          # @param [String] path an ERB template for the absolute path
          # @return [String] the absolute path to request
          def self.path(path = nil)
            return default_options[:path] unless path
            default_options[:path] = path
          end

          # @return [String] the absolute path to be used in the request
          def path
            ERB.new(self.class.path).result binding
          end

          # Allows setting POST data to be sent in each request.
          # @param [String] post_data an ERB template for the POST data
          # @return [String] the POST data for the request
          def self.post_data(post_data = nil)
            return default_options[:post_data] unless post_data
            default_options[:post_data] = post_data
          end

          # @return [String] the POST data for the request
          def post_data
            ERB.new(self.class.post_data).result binding
          end
        end
      end
    end
  end
end

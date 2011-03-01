module GovKit
  module CA
    module PostalCode
      module Strategy
        # Abstract class for implementing postal code to electoral district
        # strategies.
        #
        # The following methods must be implemented in sub-classes:
        #
        # * `find_electoral_districts_by_postal_code`
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
          def find_electoral_districts_by_postal_code
            valid? && electoral_districts.map(&:to_i)
          end

        private

          # Returns the electoral districts within a postal code.
          # @return [Array<Fixnum>] the electoral districts within the postal code
          def electoral_districts
            raise NotImplementedError
          end

          # @return [Boolean] whether the electoral districts can be determined
          def valid?
            true
          end
        end
      end
    end
  end
end

module GovKit
  module CA
    module PostalCode
      # The set of postal code to electoral district strategies.
      module StrategySet
        # Stores the strategy set.
        # @return [Array<Strategy::Base>] the strategy set
        def self.strategies
          @@strategies ||= []
        end

        # Adds a strategy to the strategy set.
        # @param [Strategy::Base] strategy a strategy
        # @return [Array<Strategy::Base>] the strategy set
        def self.register(strategy)
          strategies << strategy unless strategies.include?(strategy)
        end

        # Runs through the strategies in order of registration. Returns the
        # output of the first strategy to successfully determine electoral
        # districts from a postal code.
        # @param [String] postal_code a postal code
        # @return [Array<Fixnum>] the electoral districts within the postal code
        # @raise [ResourceNotFound] if no strategy succeeds
        def self.run(postal_code)
          strategies.each do |strategy|
            begin
              electoral_districts = strategy.new(postal_code).electoral_districts
              return electoral_districts if electoral_districts
            rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET,
              Errno::ETIMEDOUT, EOFError, Net::HTTPBadResponse,
              Net::HTTPHeaderSyntaxError, Net::ProtocolError
              # Do nothing. Continue.
            end
          end

          raise ResourceNotFound
        end
      end
    end
  end
end

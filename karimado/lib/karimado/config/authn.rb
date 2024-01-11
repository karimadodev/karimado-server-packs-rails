module Karimado
  class Config
    class Authn
      attr_reader :access_token_lifetime, :refresh_token_lifetime, :refresh_token_grace_period

      def initialize
        self.access_token_lifetime = 2.hours
        self.refresh_token_lifetime = 24.hours
        self.refresh_token_grace_period = 30.seconds
      end

      def access_token_lifetime=(value)
        raise ArgumentError, "access token lifetime at least 5 minutes" if value < 5.minutes
        raise ArgumentError, "access token lifetime no more than 24 hours" if value > 24.hours
        @access_token_lifetime = value
      end

      def refresh_token_lifetime=(value)
        raise ArgumentError, "refresh token lifetime at least 60 minutes" if value < 60.minutes
        raise ArgumentError, "refresh token lifetime no more than 12 months" if value > 12.months
        @refresh_token_lifetime = value
      end

      def refresh_token_grace_period=(value)
        raise ArgumentError, "refresh token grace period at least 0 seconds" if value < 0.seconds
        raise ArgumentError, "refresh token grace period no more than 2 minutes" if value > 2.minutes
        @refresh_token_grace_period = value
      end
    end
  end
end

module Karimado
  class UserSession < ApplicationRecord
    belongs_to :user

    has_secure_token :access_token_base, length: 36
    has_secure_token :refresh_token_base, length: 36

    class << self
      def access_token_expires_in
        1.hour
      end

      def refresh_token_expires_in
        1.day
      end
    end

    def access_token(expires_in: nil)
      expires_in ||= self.class.access_token_expires_in
      UserSessionAccessToken.encode(self, expires_in:)
    end

    def refresh_token(expires_in: nil)
      expires_in ||= self.class.refresh_token_expires_in
      UserSessionRefreshToken.encode(self, expires_in:)
    end
  end
end

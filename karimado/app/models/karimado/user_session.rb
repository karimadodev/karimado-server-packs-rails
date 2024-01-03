module Karimado
  class UserSession < ApplicationRecord
    include Models::HasPublicId

    belongs_to :user

    has_public_id :public_id
    has_secure_token :access_token_base
    has_secure_token :refresh_token_base

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

module Karimado
  class UserSession < ApplicationRecord
    include Discard::Model
    include Models::HasPublicId

    belongs_to :user

    has_public_id :public_id
    has_secure_token :access_token_base
    has_secure_token :refresh_token_base

    def authn_token
      access_token_expires_in = Karimado.configuration.authn.access_token_expires_in
      refresh_token_expires_in = Karimado.configuration.authn.refresh_token_expires_in

      {
        access_token: access_token(expires_in: access_token_expires_in),
        access_token_expires_in:,
        refresh_token: refresh_token(expires_in: refresh_token_expires_in),
        refresh_token_expires_in:
      }
    end

    def access_token(expires_in:)
      UserSessionAccessToken.encode(self, expires_in:)
    end

    def refresh_token(expires_in:)
      UserSessionRefreshToken.encode(self, expires_in:)
    end
  end
end

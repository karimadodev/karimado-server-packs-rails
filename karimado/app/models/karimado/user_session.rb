module Karimado
  class UserSession < ApplicationRecord
    include Discard::Model
    include Karimado::Concerns::Models::HasPublicId

    belongs_to :user

    has_public_id :public_id
    has_secure_token :access_token_base
    has_secure_token :refresh_token_base

    before_save -> {
      self.previous_refresh_token_base = refresh_token_base_in_database
      self.previous_refresh_token_base_revoked_at = Time.now
    }, if: :will_save_change_to_refresh_token_base?

    def authn_token
      {
        access_token: access_token(expires_in: access_token_expires_in),
        access_token_expires_in:,
        refresh_token: refresh_token(expires_in: refresh_token_expires_in),
        refresh_token_expires_in:
      }
    end

    def valid_current_access_token?(token)
      access_token_base == token.access_token
    end

    def valid_current_refresh_token?(token)
      refresh_token_base == token.refresh_token
    end

    def valid_previous_refresh_token?(token)
      previous_refresh_token_base == token.refresh_token &&
        previous_refresh_token_base_revoked_at + refresh_token_grace_period > Time.now
    end

    private

    def access_token(expires_in:)
      UserSessionAccessToken.encode(self, expires_in:)
    end

    def refresh_token(expires_in:)
      UserSessionRefreshToken.encode(self, expires_in:)
    end

    def access_token_expires_in
      Karimado.config.authn.access_token_lifetime
    end

    def refresh_token_expires_in
      Karimado.config.authn.refresh_token_lifetime
    end

    def refresh_token_grace_period
      Karimado.config.authn.refresh_token_grace_period
    end
  end
end

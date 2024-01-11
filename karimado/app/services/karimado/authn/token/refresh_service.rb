module Karimado
  module Authn
    module Token
      class RefreshService < ApplicationService
        def call(refresh_token:)
          token = decode_token!(refresh_token)
          session = token.session
          error!("token has been revoked") if session.discarded?
          error!("token has been revoked") if session.refresh_token_base != token.refresh_token

          ActiveRecord::Base.transaction do
            session.regenerate_refresh_token_base
            session.regenerate_access_token_base
          end
          session.authn_token
        end

        private

        def decode_token!(refresh_token)
          UserSessionRefreshToken.decode(refresh_token)
        rescue Errors::InvalidToken => e
          error!(e.message)
        end
      end
    end
  end
end

module Karimado
  module Authn
    module Token
      class RefreshService < ApplicationService
        def call(refresh_token:)
          token = decode_token!(refresh_token)
          session = token.session
          error!("token has been revoked") if session.discarded?

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

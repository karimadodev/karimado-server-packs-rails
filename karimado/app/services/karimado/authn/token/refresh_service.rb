module Karimado
  module Authn
    module Token
      class RefreshService < ApplicationService
        def call(refresh_token:)
          token = decode_token!(refresh_token)
          session = token.session
          error!("token has been revoked") if session.nil?
          error!("token has been revoked") if session.discarded?

          session.with_lock do
            if session.valid_current_refresh_token?(token)
              session.regenerate_refresh_token_base
              session.regenerate_access_token_base
            elsif session.valid_previous_refresh_token?(token)
              nil
            else
              error!("token has been revoked")
            end
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

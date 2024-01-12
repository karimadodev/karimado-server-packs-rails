module Karimado
  module Authn
    module Token
      class RevokeService < ApplicationService
        def call(refresh_token:)
          token = decode_token!(refresh_token)
          session = token.session
          ok! if session.discarded?

          if session.valid_current_refresh_token?(token)
            session.discard!
          else
            error!("token has been revoked")
          end

          nil
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

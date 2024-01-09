module Karimado
  module Authn
    module Token
      class RevokeService < ApplicationService
        def call(refresh_token:)
          token = decode_token!(refresh_token)
          session = token.session
          ok! if session.discarded?

          session.discard!
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

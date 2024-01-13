module Karimado
  module Authn
    module Token
      class RevokeService < ApplicationService
        def call(access_token:)
          token = decode_token!(access_token)
          session = token.session
          ok! if session.nil?
          ok! if session.discarded?

          if session.valid_current_access_token?(token)
            session.discard!
          else
            error!("token has been revoked")
          end

          nil
        end

        private

        def decode_token!(access_token)
          UserSessionAccessToken.decode(access_token)
        rescue Errors::InvalidToken => e
          error!(e.message)
        end
      end
    end
  end
end

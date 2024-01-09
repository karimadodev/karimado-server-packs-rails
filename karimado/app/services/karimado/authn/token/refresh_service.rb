module Karimado
  module Authn
    module Token
      class RefreshService < ApplicationService
        def call(refresh_token:)
          begin
            token = UserSessionRefreshToken.decode(refresh_token)
          rescue Errors::InvalidToken => e
            error!(e.message)
          end

          session = token.session
          session.authn_token
        end
      end
    end
  end
end

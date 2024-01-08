module Karimado
  module Authn
    module Token
      class RefreshService < ApplicationService
        def call(refresh_token:)
          # token = UserSessionRefreshToken.decode(refresh_token)
          # session = token.session
          # session.authn_token
        end
      end
    end
  end
end

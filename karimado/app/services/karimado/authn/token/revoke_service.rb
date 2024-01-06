module Karimado
  module Authn
    module Token
      class RevokeService < ApplicationService
        def call(access_token:)
          # session = access_token.session
          # session.undiscarded? && session.discard!
        end
      end
    end
  end
end

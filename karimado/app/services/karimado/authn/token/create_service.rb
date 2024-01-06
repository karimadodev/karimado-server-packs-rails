module Karimado
  module Authn
    module Token
      class CreateService < ApplicationService
        def call(username:, password:)
          # user = User.find_or_create_by!(uid: "karimado")
          # session = user.user_sessions.create!
          # session.authn_token
        end
      end
    end
  end
end

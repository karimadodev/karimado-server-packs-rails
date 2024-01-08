module Karimado
  module Authn
    module Token
      class CreateService < ApplicationService
        def call(username:, password:)
          user = User.find_by(uid: username)
          fail!("Invalid username or password") unless user.present?
          fail!("Invalid username or password") unless user.authenticate(password)

          session = user.user_sessions.create!
          session.authn_token
        end
      end
    end
  end
end

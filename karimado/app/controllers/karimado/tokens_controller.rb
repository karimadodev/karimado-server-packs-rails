module Karimado
  class TokensController < ApplicationController
    skip_before_action :authenticate_user!, only: [:create, :refresh]

    def create
      user = User.find_or_create_by!(uid: "karimado")
      session = user.user_sessions.create!
      render_success(session.authn_token)
    end

    def refresh
      token = UserSessionRefreshToken.decode(params[:token])
      session = token.session
      render_success(session.authn_token)
    end

    def revoke
      session = current_user_session
      session.undiscarded? && session.discard!
      render_success
    end
  end
end

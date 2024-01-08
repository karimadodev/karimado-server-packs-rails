module Karimado
  class TokensController < ApplicationController
    skip_before_action :authenticate_user!, only: [:create, :refresh]

    def create
      result = Authn::Token::CreateService.call!(
        username: params[:username],
        password: params[:password]
      )
      render_success(result.value)
    end

    def refresh
      result = Authn::Token::RefreshService.call!(
        refresh_token: params[:token]
      )
      render_success(result.value)
    end

    def revoke
      result = Authn::Token::RevokeService.call!(
        access_token: karimado_access_token
      )
      render_success(result.value)
    end
  end
end

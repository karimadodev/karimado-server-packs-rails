module Karimado
  class TokensController < ApplicationController
    skip_before_action :authenticate_user!, only: [:create, :refresh]

    def create
      Authn::Token::CreateService.call({
        username: params[:username],
        password: params[:password]
      })
    end

    def refresh
      Authn::Token::RefreshService.call({
        refresh_token: params[:token]
      })
    end

    def revoke
      Authn::Token::RevokeService.call({
        access_token: karimado_access_token
      })
    end
  end
end

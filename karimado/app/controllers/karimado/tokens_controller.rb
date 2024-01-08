module Karimado
  class TokensController < ApplicationController
    skip_before_action :authenticate_user!, only: [:create, :refresh]

    def create
      result = Authn::Token::CreateService.call(
        username: params[:username],
        password: params[:password]
      )
      if result.success?
        render_success(result.value)
      else
        render_failure(result.code, result.message)
      end
    end

    def refresh
      result = Authn::Token::RefreshService.call(
        refresh_token: params[:token]
      )
      if result.success?
        render_success(result.value)
      else
        render_failure(result.code, result.message)
      end
    end

    def revoke
      result = Authn::Token::RevokeService.call(
        access_token: karimado_access_token
      )
      if result.success?
        render_success(result.value)
      else
        render_failure(result.code, result.message)
      end
    end
  end
end

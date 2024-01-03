require "jwt"

module Karimado
  class UserSessionRefreshToken
    include ActiveModel::Model

    attr_accessor :sub, :iat, :exp
    attr_accessor :grant_type, :refresh_token
    attr_accessor :session_id

    class << self
      def encode(session, expires_in:)
        ::JWT.encode({
          sub: session.user.id.to_s,
          iat: Time.now.to_i,
          exp: expires_in.from_now.to_i,
          grant_type: "refresh_token",
          refresh_token: session.refresh_token_base,
          session_id: session.id
        }, hmac_secret, "HS256")
      end

      def decode(token)
        begin
          decoded_token = ::JWT.decode(token, hmac_secret, true, {algorithm: "HS256"})[0]
        rescue ::JWT::ExpiredSignature => e
          raise Errors::TokenExpired, e.message
        rescue ::JWT::DecodeError => e
          raise Errors::InvalidToken, e.message
        end

        if decoded_token["grant_type"] != "refresh_token"
          raise Errors::InvalidToken, "invalid grant type"
        end

        new(decoded_token)
      end

      private

      def hmac_secret
        ::Rails.application.secret_key_base
      end
    end
  end
end
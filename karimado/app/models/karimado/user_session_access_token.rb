require "jwt"

module Karimado
  class UserSessionAccessToken
    include ActiveModel::Model

    attr_accessor :sub, :iat, :exp
    attr_accessor :grant_type, :access_token
    attr_accessor :sid

    class << self
      def encode(session, expires_in:)
        ::JWT.encode({
          sub: session.user.public_id,
          iat: Time.now.to_i,
          exp: expires_in.from_now.to_i,
          grant_type: "access_token",
          access_token: session.access_token_base,
          sid: session.public_id
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

        if decoded_token["grant_type"] != "access_token"
          raise Errors::InvalidToken, "invalid grant type"
        end

        new(decoded_token)
      end

      private

      def hmac_secret
        ::Rails.application.secret_key_base
      end
    end

    def user
      User.find_by(public_id: sub)
    end

    def session
      UserSession.find_by(public_id: sid)
    end
  end
end

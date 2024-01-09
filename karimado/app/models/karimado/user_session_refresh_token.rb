module Karimado
  class UserSessionRefreshToken
    include ActiveModel::Model

    attr_accessor :sub, :iat, :exp
    attr_accessor :grant_type, :refresh_token
    attr_accessor :sid

    class << self
      def encode(session, expires_in:)
        ::JWT.encode({
          sub: session.user.public_id,
          iat: Time.now.to_i,
          exp: expires_in.from_now.to_i,
          grant_type: "refresh_token",
          refresh_token: session.refresh_token_base,
          sid: session.public_id
        }, hmac_secret, "HS256")
      end

      def decode(token)
        begin
          decoded_token = ::JWT.decode(token, hmac_secret, true, {algorithm: "HS256"})[0]
        rescue ::JWT::ExpiredSignature
          raise Errors::TokenExpired, "token has expired"
        rescue ::JWT::DecodeError => e
          raise Errors::InvalidToken, "invalid token: #{e.message}"
        end

        if decoded_token["grant_type"] != "refresh_token"
          raise Errors::InvalidToken, "invalid token: wrong grant type"
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

module Karimado
  module Concerns
    module Controllers
      module Authentication
        extend ActiveSupport::Concern

        included do
          before_action :authenticate_user!
        end

        private

        def authenticate_user!
          if current_user_session.nil?
            resp = API::Response.new(:unauthorized)
            render(json: resp.to_json, status: resp.http_status)
            return
          end

          if current_user_session.discarded?
            resp = API::Response.new(:unauthorized)
            render(json: resp.to_json, status: resp.http_status)
          end
        end

        def current_user
          @_current_user ||= karimado_access_token&.user
        end

        def current_user_session
          @_current_user_session ||= karimado_access_token&.session
        end

        def karimado_access_token
          return @_karimado_access_token if defined?(@_karimado_access_token)

          @_karimado_access_token = begin
            header = request.headers["Authorization"].to_s
            token = header.sub(/^Bearer\s+/, "")
            token.blank? ? nil : (
              begin
                UserSessionAccessToken.decode(token)
              rescue Errors::InvalidToken
                nil
              end
            )
          end
        end
      end
    end
  end
end

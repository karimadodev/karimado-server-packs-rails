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
          render_failure(:unauthorized) if current_user.nil?
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
            token && UserSessionAccessToken.decode(token)
          end
        end
      end
    end
  end
end

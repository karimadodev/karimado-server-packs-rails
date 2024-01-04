module Karimado
  module Controllers
    module Authentication
      extend ActiveSupport::Concern

      included do
        before_action :authenticate_user!
      end

      private

      def authenticate_user!
        render_failure(status: :unauthorized) if current_user.blank?
      end

      def current_user
        @current_user ||= karimado_token&.user
      end

      def current_user_session
        @current_user_session ||= karimado_token&.session
      end

      def karimado_token
        return @_karimado_token if defined?(@_karimado_token)
        @_karimado_token = begin
          header = request.headers["Authorization"].to_s
          token = header.sub(/^Bearer\s+/, "")
          token && UserSessionAccessToken.decode(token)
        end
      end
    end
  end
end

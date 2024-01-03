module Karimado
  module Controllers
    module Authentication
      extend ActiveSupport::Concern

      def karimado_token
        @karimado_token ||= begin
          header = request.headers["Authorization"].to_s
          token = header.sub(/^Bearer\s+/, "")
          UserSessionAccessToken.decode(token)
        end
      end
    end
  end
end

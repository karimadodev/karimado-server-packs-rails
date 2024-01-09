module Karimado
  module Concerns
    module Controllers
      module Authentication
        extend ActiveSupport::Concern

        included do
          before_action :karimado_authenticate!
        end

        private

        def karimado_authenticate!
          token = karimado_access_token
          if token.nil?
            resp = API::Response.new(:unauthorized)
            render(json: resp.to_json, status: resp.http_status)
            return
          end

          session = token.session
          if session.nil? || session.discarded?
            resp = API::Response.new(:unauthorized)
            render(json: resp.to_json, status: resp.http_status)
          end
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

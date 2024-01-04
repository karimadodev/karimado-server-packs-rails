module Karimado
  module Controllers
    module Rendering
      extend ActiveSupport::Concern

      def render_success(data = {}, message: nil, status: nil)
        message ||= "ok"
        status ||= :ok
        render(json: {code: 0, message:, data:}, status:)
      end

      def render_failure(errors = {}, code: 1, message: nil, status: nil)
        message ||= "err"
        status ||= :internal_server_error
        render(json: {code:, message:, errors:}, status:)
      end
    end
  end
end

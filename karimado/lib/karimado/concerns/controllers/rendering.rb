module Karimado
  module Concerns
    module Controllers
      module Rendering
        extend ActiveSupport::Concern

        private

        def render_success(data = nil)
          resp = API::Response.new(:ok, nil, data:)
          render(json: resp.to_json, status: resp.http_status)
        end

        def render_failure(code_or_message = nil, message = nil)
          resp =
            if code_or_message.is_a?(Symbol)
              raise ArgumentError if code_or_message == :ok
              API::Response.new(code_or_message, message)
            elsif code_or_message.is_a?(Numeric)
              raise ArgumentError if code_or_message == 0
              API::Response.new(code_or_message, message)
            else
              API::Response.new(:error, message || code_or_message)
            end
          render(json: resp.to_json, status: resp.http_status)
        end
      end
    end
  end
end

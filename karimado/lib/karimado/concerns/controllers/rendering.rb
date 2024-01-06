module Karimado
  module Concerns
    module Controllers
      module Rendering
        extend ActiveSupport::Concern

        private

        def render_success(data = nil, status: nil)
          resp = Karimado::API::Response.new(:ok, nil, data:)
          render(json: resp, status: status || :ok)
        end

        def render_failure(code_or_message = nil, message = nil, status: nil)
          resp =
            if code_or_message.is_a?(Symbol)
              raise ArgumentError if code_or_message == :ok
              Karimado::API::Response.new(code_or_message, message)
            elsif code_or_message.is_a?(Numeric)
              raise ArgumentError if code_or_message == 0
              Karimado::API::Response.new(code_or_message, message)
            else
              Karimado::API::Response.new(:error, message || code_or_message)
            end
          render(json: resp, status: status || :internal_server_error)
        end
      end
    end
  end
end

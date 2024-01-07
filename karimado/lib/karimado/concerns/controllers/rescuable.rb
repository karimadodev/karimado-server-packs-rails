module Karimado
  module Concerns
    module Controllers
      module Rescuable
        extend ActiveSupport::Concern

        rescue_from StandardError do |e|
          render_failure(e.message)
        end

        rescue_from ApplicationService::Error do |e|
          result = e.result
          render_failure(result.code, result.message)
        end
      end
    end
  end
end

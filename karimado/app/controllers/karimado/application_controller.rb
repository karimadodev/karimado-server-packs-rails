module Karimado
  class ApplicationController < ActionController::API
    include Karimado::Concerns::Controllers::Authentication
    include Karimado::Concerns::Controllers::Rendering

    rescue_from ApplicationService::Error do |e|
      result = e.result
      render_failure(result.code, result.message)
    end
  end
end

module Karimado
  class ApplicationController < ActionController::API
    include Karimado::Concerns::Controllers::Authentication
    include Karimado::Concerns::Controllers::Rendering
  end
end

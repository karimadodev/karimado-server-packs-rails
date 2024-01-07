module Karimado
  class ApplicationController < ActionController::API
    include Karimado::Concerns::Controllers::Authentication
    include Karimado::Concerns::Controllers::Rendering
    include Karimado::Concerns::Controllers::Rescuable
  end
end

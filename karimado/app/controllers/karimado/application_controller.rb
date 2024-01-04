module Karimado
  class ApplicationController < ActionController::API
    include Controllers::Authentication
    include Controllers::Rendering
  end
end

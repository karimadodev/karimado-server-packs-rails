require "discard"
require "jwt"

require "karimado/api/response/code/reasons"
require "karimado/api/response/code"
require "karimado/api/response"
require "karimado/configuration"
require "karimado/engine"
require "karimado/errors"
require "karimado/version"

require "karimado/concerns/controllers/authentication"
require "karimado/concerns/controllers/rendering"
require "karimado/concerns/models/has_public_id"
require "karimado/concerns/services/callable"

module Karimado
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
    end
  end
end

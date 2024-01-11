require "discard"
require "jwt"

require "karimado/api/response/code/reasons"
require "karimado/api/response/code"
require "karimado/api/response"
require "karimado/config/authn"
require "karimado/config"
require "karimado/engine"
require "karimado/errors"
require "karimado/version"

require "karimado/concerns/controllers/authentication"
require "karimado/concerns/controllers/rendering"
require "karimado/concerns/models/has_public_id"
require "karimado/concerns/services/callable"

module Karimado
  class << self
    def config
      @config ||= Config.new
    end

    def configure
      yield config
    end
  end
end

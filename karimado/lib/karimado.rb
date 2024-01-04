require "discard"
require "jwt"

require "karimado/configuration"
require "karimado/engine"
require "karimado/errors"
require "karimado/version"

require "karimado/concerns/controllers/authentication"
require "karimado/concerns/controllers/rendering"
require "karimado/concerns/models/has_public_id"

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

module Karimado
  class Configuration
    attr_reader :authn

    def initialize
      @authn = ActiveSupport::OrderedOptions.new
      @authn.access_token_expires_in = 1.hour
      @authn.refresh_token_expires_in = 1.day
    end
  end
end

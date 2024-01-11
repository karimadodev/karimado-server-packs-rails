module Karimado
  class Config
    attr_reader :authn

    def initialize
      @authn = Authn.new
    end
  end
end

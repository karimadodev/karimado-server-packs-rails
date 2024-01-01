module Karimado
  class Engine < ::Rails::Engine
    isolate_namespace Karimado

    config.generators do |g|
      g.api_only = true
      g.test_framework :rspec
    end
  end
end

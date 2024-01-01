module Karimado
  class Engine < ::Rails::Engine
    isolate_namespace Karimado
    config.generators.api_only = true
  end
end

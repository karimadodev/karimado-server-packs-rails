require_relative "lib/karimado/version"

Gem::Specification.new do |spec|
  spec.name = "karimado"
  spec.version = Karimado::VERSION
  spec.authors = ["The Karimado Team"]
  spec.email = []
  spec.homepage = "https://github.com/souk4711/karimado-server-packs-rails"
  spec.summary = "Karimado Server Packages + Rails"
  spec.description = "Karimado Server Packages + Rails"
  spec.license = "LGPL"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/souk4711/karimado-server-packs-rails"
  spec.metadata["changelog_uri"] = "https://github.com/souk4711/karimado-server-packs-rails"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "bcrypt"
  spec.add_dependency "rails", ">= 7.1.2"
end

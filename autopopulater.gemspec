require_relative "lib/autopopulater/version"

Gem::Specification.new do |spec|
  spec.name        = "autopopulater"
  spec.version     = Autopopulater::VERSION
  spec.authors     = ["David Van Der Beek"]
  spec.email       = ["earlynovrock@gmail.com"]
  spec.homepage    = "https://github.com/dvanderbeek/autopopulater"
  spec.summary     = "Autopopulate Rails model attributes via remote APIs"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/dvanderbeek/autopopulater"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_development_dependency "debug", ">= 1.0.0"
  spec.add_dependency "rails", ">= 7.1.3.4"
end

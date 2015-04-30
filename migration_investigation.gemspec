# -*- encoding: utf-8 -*-
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "migration_investigation/version"

Gem::Specification.new do |gem|
  gem.name          = "migration_investigation"
  gem.version       = MigrationInvestigation::VERSION
  gem.authors       = ["Brent Wheeldon"]
  gem.email         = ["brent.wheeldon@gmail.com"]
  gem.description   = %q{Checks whether migrations, or other operations, need to be run, without loading your environment}
  gem.summary       = %q{Checks whether migrations, or other parts of your repo, have any changes.}
  gem.homepage      = "https://github.com/BrentWheeldon/migration_investigation"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "auto_tagger", "~> 0"
  gem.add_development_dependency "rspec", "~> 3"
end

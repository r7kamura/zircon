# -*- encoding: utf-8 -*-
require File.expand_path('../lib/zircon/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ryo NAKAMURA"]
  gem.email         = ["r7kamura@gmail.com"]
  gem.description   = "Zircon is a mineral belonging to the group of nesosilicates."
  gem.summary       = "IRC client library written in Pure Ruby"
  gem.homepage      = "https://github.com/r7kamura/zircon"

  gem.metadata["homepage_uri"] = gem.homepage
  gem.metadata["source_code_uri"] = gem.homepage
  gem.metadata["changelog_uri"] = "#{gem.homepage}/releases"
  gem.metadata["rubygems_mfa_required"] = "true"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "zircon"
  gem.require_paths = ["lib"]
  gem.version       = Zircon::VERSION

  gem.required_ruby_version = ">= 3.3"

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rspec-its"
end

# -*- encoding: utf-8 -*-
require File.expand_path('../lib/zircon/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ryo NAKAMURA"]
  gem.email         = ["r7kamura@gmail.com"]
  gem.description   = "Zircon is a mineral belonging to the group of nesosilicates."
  gem.summary       = "IRC client library written in Pure Ruby"
  gem.homepage      = "https://github.com/r7kamura/zircon"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "zircon"
  gem.require_paths = ["lib"]
  gem.version       = Zircon::VERSION

  gem.add_development_dependency "rspec"
end

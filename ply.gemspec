# -*- encoding: utf-8 -*-

require File.expand_path('../lib/pliable/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "pliable"
  gem.version       = Pliable::VERSION
  gem.summary       = %q{TODO: Summary}
  gem.description   = %q{TODO: Description}
  gem.license       = "MIT"
  gem.authors       = ["Mike Piccolo"]
  gem.email         = "mfpiccolo@gmail.com"
  gem.homepage      = "https://rubygems.org/gems/pliable"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_runtime_dependency "rails",  ">= 4.0"

  gem.add_development_dependency 'bundler', '~> 1.0'
  gem.add_development_dependency 'rake', '~> 0.8'
  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'mocha'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'pry-debugger'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
  gem.add_development_dependency 'yard', '~> 0.8'

  gem.add_development_dependency "rails",  ">= 4.0"
  gem.add_development_dependency "pg"
  gem.add_development_dependency "activerecord-nulldb-adapter"
end

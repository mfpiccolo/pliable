# -*- encoding: utf-8 -*-

require File.expand_path('../lib/pliable/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "pliable"
  gem.version       = Pliable::VERSION
  gem.summary       = "Schemaless data integration with Rails and Postgres"
  gem.description   = "Pliable makes integrating a Rails project with Schemaless data not so painful"
  gem.license       = "MIT"
  gem.authors       = ["Mike Piccolo"]
  gem.email         = "mfpiccolo@gmail.com"
  gem.homepage      = "https://rubygems.org/gems/pliable"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_runtime_dependency "rails",  ">= 4.0"
  gem.add_runtime_dependency "pg",     ">= 0.17"

  gem.add_development_dependency 'bundler', '~> 1.0'
  gem.add_development_dependency 'rake', '>= 0.8'
  gem.add_development_dependency 'minitest', ">= 4.7.5"
  gem.add_development_dependency 'mocha',    "~> 1.0.0"
  gem.add_development_dependency 'pry',      "~> 0.9.12"
  gem.add_development_dependency 'pry-debugger', "~> 0.2"
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
  gem.add_development_dependency 'yard', '~> 0.8'
  gem.add_development_dependency "rails",  ">= 4.0"
  gem.add_development_dependency "pg",     "~> 0.17.1"
  gem.add_development_dependency "rspec",  "~> 2.14"
  gem.add_development_dependency "database_cleaner", "~> 1.0"
end

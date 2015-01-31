# -*- encoding: utf-8 -*-
require File.expand_path('../lib/gov_kit-ca/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "govkit-ca"
  s.version     = GovKit::CA::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Open North"]
  s.email       = ["info@opennorth.ca"]
  s.homepage    = "https://github.com/opennorth/govkit-ca"
  s.summary     = %q{Easy access to Canadian civic data around the web}
  s.description = %q{GovKit-CA lets you quickly get encapsulated Ruby objects for Canadian civic data.}

  s.rubyforge_project = "govkit-ca"
  s.license     = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency('faraday')
  s.add_runtime_dependency('httparty', '~> 0.10.0')
  s.add_runtime_dependency('nokogiri', '~> 1.6.0')
  s.add_development_dependency('json')
  s.add_development_dependency('rspec', '~> 2.6.0')
  s.add_development_dependency('rake', '~> 10.1.0')
  s.add_development_dependency('coveralls')
  s.add_development_dependency('mime-types', '~> 1.16')
end

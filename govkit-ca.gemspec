# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "gov_kit-ca/version"

Gem::Specification.new do |s|
  s.name        = "govkit-ca"
  s.version     = GovKit::CA::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Open North"]
  s.email       = ["info@opennorth.ca"]
  s.homepage    = "http://github.com/opennorth/govkit-ca"
  s.summary     = %q{Easy access to Canadian civic data around the web}
  s.description = %q{GovKit-CA lets you quickly get encapsulated Ruby objects for Canadian civic data.}

  s.rubyforge_project = "govkit-ca"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency('httparty', '~> 0.7.8')
  s.add_runtime_dependency('nokogiri', '~> 1.5.0')
  s.add_runtime_dependency('yajl-ruby', '~> 0.8.2')
  s.add_development_dependency('rspec', '~> 2.6.0')
  s.add_development_dependency('fakeweb', '~> 1.3.0')
end

# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)

require "has_slug"

Gem::Specification.new do |s|
  s.name              = "has_slug"
  s.version           = HasSlug::VERSION
  s.authors           = ["Anton Petrunich"]
  s.email             = ["anton.petrunich@gmail.com"]
  s.homepage          = "http://github.com/solenko/has_slug"
  s.summary           = "Add slug functionality for your ActiveRecord models."
  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths     = ["lib"]

  s.add_dependency "activerecord", "~> 3.2.0"
  s.add_dependency "railties", "~> 3.2.0"

  s.add_development_dependency "railties", "~> 3.2.0"
  s.add_development_dependency "activerecord", "~> 3.2.0"
  s.add_development_dependency "rspec", "~> 2.11"
  s.add_development_dependency "i18n"
end

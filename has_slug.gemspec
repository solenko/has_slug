# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)

require "has_slug/version"

Gem::Specification.new do |s|
  s.name              = "has_slug"
  s.version           = HasSlug::VERSION
  s.authors           = ["Anton Petrunich"]
  s.email             = ["anton.petrunich@gmail.com"]
  s.homepage          = "http://github.com/solenko/has_slug"
  s.summary           = "Add slug functionality for your ActiveRecord models."
  s.files             = Dir.glob("{lib}/**/*")
  s.test_files        = Dir.glob("{spec}/**/*")
  s.require_paths     = ["lib"]

  s.add_dependency "activerecord", ">= 4.0.0"
  s.add_dependency "railties", ">= 4.0.0"

  s.add_development_dependency "rspec", ">= 3.0.0"
end

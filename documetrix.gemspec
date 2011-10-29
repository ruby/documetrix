# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "documetrix/version"

Gem::Specification.new do |s|
  s.name        = "documetrix"
  s.version     = Documetrix::VERSION
  s.authors     = ["madebydna"]
  s.email       = ["info@madebydna.com"]
  s.homepage    = ""
  s.summary     = %q{Generates reports to quantify documentation coverage}
  s.description = %q{Generates reports to quantify documentation coverage, also in comparision with documentation standards set by other ruby gems}

  s.rubyforge_project = "documetrix"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_runtime_dependency "rdoc"
end

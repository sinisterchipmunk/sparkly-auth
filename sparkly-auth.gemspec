# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "auth/version"

Gem::Specification.new do |s|
  s.name        = "sparkly-auth"
  s.version     = Auth::VERSION
  s.authors     = ["Colin MacKenzie IV"]
  s.email       = ["sinisterchipmunk@gmail.com"]
  s.homepage    = "http://github.com/sinisterchipmunk/sparkly-auth"
  s.summary     = %q{User authentication with Sparkles!}
  s.description = %q{As fate would have it, I found other authentication solutions unable to suit my needs. So I rolled my own, totally supporting Rails 2 AND 3.}

  s.rubyforge_project = "sparkly-auth"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency(%q<sc-core-ext>, ["~> 1.2.1"])
  s.add_development_dependency 'rake', '0.9.2'
  s.add_development_dependency 'bundler', '1.0.15'
end

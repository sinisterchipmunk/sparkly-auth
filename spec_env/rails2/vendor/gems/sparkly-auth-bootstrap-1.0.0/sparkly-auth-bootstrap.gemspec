# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sparkly-auth-bootstrap}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Colin MacKenzie IV"]
  s.date = %q{2010-08-09}
  s.description = %q{As fate would have it, I found other authentication solutions unable to suit my needs. So I rolled my own.}
  s.email = %q{sinisterchipmunk@gmail.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
     "init.rb",
     "lib/sparkly-auth.rb",
  ]
  s.homepage = %q{http://www.thoughtsincomputation.com}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{User authentication with Sparkles!}
  s.test_files = [
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sc-core-ext>, [">= 1.2.0"])
      s.add_development_dependency(%q<rspec-rails>, [">= 1.3.2"])
      s.add_development_dependency(%q<webrat>, [">= 0.7.1"])
      s.add_development_dependency(%q<genspec>, [">= 0.1.1"])
      s.add_development_dependency(%q<email_spec>, [">= 0.6.2"])
    else
      s.add_dependency(%q<sc-core-ext>, [">= 1.2.0"])
      s.add_dependency(%q<rspec-rails>, [">= 1.3.2"])
      s.add_dependency(%q<webrat>, [">= 0.7.1"])
      s.add_dependency(%q<genspec>, [">= 0.1.1"])
      s.add_dependency(%q<email_spec>, [">= 0.6.2"])
    end
  else
    s.add_dependency(%q<sc-core-ext>, [">= 1.2.0"])
    s.add_dependency(%q<rspec-rails>, [">= 1.3.2"])
    s.add_dependency(%q<webrat>, [">= 0.7.1"])
    s.add_dependency(%q<genspec>, [">= 0.1.1"])
    s.add_dependency(%q<email_spec>, [">= 0.6.2"])
  end
end

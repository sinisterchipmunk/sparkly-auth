if !ENV['BUNDLE_GEMFILE']
  ENV['BUNDLE_GEMFILE'] = File.expand_path("Gemfile.rails3", File.dirname(__FILE__))
end

require 'rubygems'
require 'bundler'
require 'bundler/gem_tasks'
Bundler.setup

begin
  require 'spec/rake/spectask'
  Spec::Rake::SpecTask.new(:spec) do |spec|
    spec.libs << 'lib' << 'spec'
    spec.spec_files = FileList['spec/**/*_spec.rb']
    spec.spec_opts << '--color'
  end
  
  Spec::Rake::SpecTask.new(:rcov) do |spec|
    spec.libs << 'lib' << 'spec'
    spec.pattern = 'spec/**/*_spec.rb'
    spec.rcov = true
    spec.rcov_opts = %w{--rails --exclude osx\/objc,gems\/,spec\/,features\/}
  end
rescue LoadError
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec) do |spec|
    spec.pattern = "spec/**/*_spec.rb"
  end
  
  RSpec::Core::RakeTask.new(:rcov) do |spec|
    spec.pattern = "spec/**/*_spec.rb"
    spec.rcov = true
    spec.rcov_opts = %w{--rails --exclude osx\/objc,gems\/,spec\/,features\/}
  end
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "sparkly-auth #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('HISTORY*')
  rdoc.rdoc_files.include('LICENSE*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

# Haven't got this working yet.
#namespace :spec do
#  desc "runs specs, and if they pass, runs Rails2 specs and then Rails3 specs."
#  task :all => [:spec, :rails2, :rails3]
#  
#  desc "runs Rails2 specs"
#  task :rails2 do
#    system("cd spec/support/rails2 && spec spec -c && cucumber")
#  end
#  
#  desc "runs Rails3 specs"
#  task :rails3 do
#    system("cd spec/support/rails3 && rspec spec -c && cucumber")
#  end
#end

require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "sparkly-auth"
    gem.summary = %Q{User authentication with Sparkles!}
    gem.description = %Q{As fate would have it, I found other authentication solutions unable to suit my needs. So I rolled my own.}
    gem.email = "sinisterchipmunk@gmail.com"
    gem.homepage = "http://www.thoughtsincomputation.com"
    gem.authors = ["Colin MacKenzie IV"]
    gem.add_dependency "sc-core-ext", ">= 1.2.1"
    gem.add_development_dependency 'rspec-rails', '>= 1.3.2'
    gem.add_development_dependency 'webrat', '>= 0.7.1'
    gem.add_development_dependency 'genspec', '>= 0.1.1'
    gem.add_development_dependency 'email_spec', '>= 0.6.2'
    # WHY does jeweler insist on using test/* files? THEY DON'T EXIST!
    gem.test_files = FileList['spec/**/*'] + FileList['spec_env/**/*'] + FileList['features/**/*']
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

begin
  require 'spec/rake/spectask'
  Spec::Rake::SpecTask.new(:spec) do |spec|
    spec.libs << 'lib' << 'spec'
    spec.spec_files = FileList['spec/**/*_spec.rb']
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

task :spec => :check_dependencies

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

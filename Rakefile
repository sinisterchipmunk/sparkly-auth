require 'rubygems'
require 'bundler/gem_tasks'

# If the Gemfile isn't specified (`rake`) or doesn't point to one of the expected
# gemfiles, then we need to override the gemfile variable and run specs in a subprocess.
BUNDLED = ENV['BUNDLE_GEMFILE'] && ENV['BUNDLE_GEMFILE'] =~ /\.rails([23])$/ && $1

def run_in_each_environment(*args)
  %w(rails2 rails3).each do |env|
    ENV['BUNDLE_GEMFILE'] = File.expand_path("gemfiles/Gemfile.#{env}", File.dirname(__FILE__))
    exit $? unless system(*args)
  end
end

def rerun_in_each_environment!
  run_in_each_environment 'rake', *ARGV
end

namespace :bundle do
  desc "Runs `bundle install` with both Gemfiles"
  task :install do
    run_in_each_environment 'bundle', 'install'
  end
end

if BUNDLED
  require 'bundler'
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

  require "cucumber/rake/task"
  task :cucumber do
    exit $? unless system("bundle", "exec", "cucumber")
  end
  # Cucumber::Rake::Task.new(:cucumber) do |task|
    # task.cucumber_opts = ["-t","@#{ENV["TAG"] || "all" }", File.expand_path("features", File.dirname(__FILE__))]
  # end

  task :default => [:spec, :cucumber]
  
  
  # this is a great way to get the rails rake tasks here so we don't have to 
  # chdir into rails each time; however, it also conflicts with existing tasks
  # (such as :default, etc).
  #
  # if BUNDLED == '2' # Rails 2
  #   load File.expand_path(File.join('spec_env/rails2/Rakefile'), File.dirname(__FILE__))
  # else # Rails 3
  #   load File.expand_path(File.join('spec_env/rails3/Rakefile'), File.dirname(__FILE__))
  # end
else
  desc "Run specs in both rails2 and rails3"
  task :spec do
    rerun_in_each_environment!
  end
  
  desc "Run Cucumber features in both rails2 and rails3"
  task :cucumber do
    rerun_in_each_environment!
  end
  
  desc "Run all tests in both rails2 and rails3"
  task :default do
    rerun_in_each_environment!
  end
end


# rdoc
begin
  require 'rdoc/task'
rescue LoadError
  require 'rake/rdoctask'
end

Rake::RDocTask.new do |rdoc|
  require File.join(File.dirname(__FILE__), "lib/auth/version")
  version = Auth::VERSION

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "sparkly-auth #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('HISTORY*')
  rdoc.rdoc_files.include('LICENSE*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

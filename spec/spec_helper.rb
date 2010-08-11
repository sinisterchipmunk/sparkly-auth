ENV['RAILS_ENV'] = 'test'

if defined?(RSpec)
  RSPEC_VERSION = 2
  require File.expand_path(File.join(File.dirname(__FILE__), "../spec_env/rails3/config/boot"))
  require File.expand_path(File.join(File.dirname(__FILE__), "../spec_env/rails3/config/environment"))
else
  RSPEC_VERSION = 1
  #require File.expand_path(File.join(File.dirname(__FILE__), "../spec_env/rails2/config/boot"))
  require File.expand_path(File.join(File.dirname(__FILE__), "../spec_env/rails2/config/environment"))
  require 'spec/autorun'
  require 'spec/rails'
end

require "email_spec"

begin
  require 'genspec'
rescue LoadError
  puts " >> Missing gem: 'genspec' <<"
  puts 
  puts "These specs rely on genspec, which tests the project's generators."
  puts
  raise
end

if RSPEC_VERSION == 1
  require File.join(File.dirname(__FILE__), 'spec2_helper')
else
  require File.join(File.dirname(__FILE__), 'spec3_helper')
end


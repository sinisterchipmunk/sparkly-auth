ENV['RAILS_ENV'] = 'test'

require File.expand_path("../../../../../config/boot", __FILE__)
require File.expand_path("../../../../../config/environment", __FILE__)
require "email_spec"

begin
  require 'genspec'
rescue LoadError
  puts " >> Missing gem: 'genspec' <<"
  puts 
  puts "These specs rely on gemspec, which tests the project's generators."
  puts
  raise
end

def add_load_path(path)
  path = File.expand_path(File.join("..", path), __FILE__)
  $LOAD_PATH.unshift path
  ActiveSupport::Dependencies.load_paths.unshift path
  ActiveSupport::Dependencies.load_once_paths.delete path
end

# Add mock paths to load paths
add_load_path "mocks/models"
add_load_path "../app/models"
#add_load_path "../app/lib"
add_load_path "../app/controllers"

$LOAD_PATH.uniq!
ActiveSupport::Dependencies.load_paths.uniq!
ActiveSupport::Dependencies.load_once_paths.uniq!

undef add_load_path

def column(name)
  ActiveRecord::ConnectionAdapters::Column.new(name, nil)
end

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |fi| require fi }

Spec::Runner.configure do |config|
  # Needed in order to reset configuration for each test. This should not happen in a real environment.
  config.before(:each) do
    Auth.reset_configuration!
    Dispatcher.cleanup_application
    Dispatcher.reload_application
  end
  
  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)
end

def error_on(model, key, value = nil, options = {})
  instance = model.new()
  instance.send("#{key}=", value)
  options.each { |k,v| instance.send("#{k}=", v) }

  instance.valid?
  instance.errors.on(key.to_s)
end

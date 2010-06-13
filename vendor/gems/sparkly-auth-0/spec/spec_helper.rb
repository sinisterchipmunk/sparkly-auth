ENV['RAILS_ENV'] = 'test'

require File.expand_path("../../../../../config/boot", __FILE__)
require File.expand_path("../../../../../config/environment", __FILE__)

require 'genspec'

def add_load_path(path)
  path = File.expand_path(File.join("..", path), __FILE__)
  $LOAD_PATH << path
  ActiveSupport::Dependencies.load_paths << path
  ActiveSupport::Dependencies.load_once_paths.delete path
end


# Add mock paths to load paths
add_load_path "mocks/models"

undef add_load_path

def column(name)
  ActiveRecord::ConnectionAdapters::Column.new(name, nil)
end

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |fi| require fi }

Spec::Runner.configure do |config|
  # Needed in order to reset configuration for each test. This should not happen in a real environment.
  config.before(:each) { Auth.reset_configuration! }

  config.after(:each) do
#    Dispatcher.cleanup_application
    silence_warnings do
      Object.send(:const_set, :User, Class.new(ActiveRecord::Base))
      Object.send(:const_set, :Password, Class.new(ActiveRecord::Base))
    end
#    Dispatcher.reload_application
  end
end

def error_on(model, key, value = nil, options = {})
  instance = model.new()
  instance.send("#{key}=", value)
  options.each { |k,v| instance.send("#{k}=", v) }

  instance.valid?
  instance.errors.on(key.to_s)
end

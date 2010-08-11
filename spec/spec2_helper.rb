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

def reload!
  if Rails.configuration.cache_classes
    raise "Cannot reload: set Rails.configuration.cache_classes to false first"
  end
  Dispatcher.cleanup_application
  Dispatcher.reload_application
end

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  # Needed in order to reset configuration for each test. This should not happen in a real environment.
  config.before(:each) do
    # Why do I have to do this?!
    User.destroy_all
    Password.destroy_all
    RemembranceToken.destroy_all

    Auth.reset_configuration!
    reload!
  end
  
  config.after(:each) do
#    # Why do I have to do this?!
#    User.destroy_all
#    Password.destroy_all
#    RemembranceToken.destroy_all
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

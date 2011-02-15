ENV['RAILS_ENV'] = 'test'

def add_load_path(path)
  path = File.expand_path(File.join("..", path), __FILE__)
  $LOAD_PATH.unshift path
  if ActiveSupport::Dependencies.respond_to?(:autoload_paths)
    ActiveSupport::Dependencies.autoload_paths.unshift path
    ActiveSupport::Dependencies.autoload_once_paths.delete path
  else
    ActiveSupport::Dependencies.load_paths.unshift path
    ActiveSupport::Dependencies.load_once_paths.delete path
  end
end

# Add mock paths to load paths
add_load_path "mocks/models"
add_load_path "../app/models"
#add_load_path "../app/lib"
add_load_path "../app/controllers"

$LOAD_PATH.uniq!
if ActiveSupport::Dependencies.respond_to?(:autoload_paths)
  ActiveSupport::Dependencies.autoload_paths.uniq!
  ActiveSupport::Dependencies.autoload_once_paths.uniq!
else
  ActiveSupport::Dependencies.load_paths.uniq!
  ActiveSupport::Dependencies.load_once_paths.uniq!
end

undef add_load_path

def column(name)
  ActiveRecord::ConnectionAdapters::Column.new(name, nil)
end

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |fi| require fi }

Spec::Runner.configure do |config|
  # Needed in order to reset configuration for each test. This should not happen in a real environment.
  config.before(:each) do
    Auth.reset_double_prevention!
    apply_sparkly_configuration!

    User.destroy_all
    Password.destroy_all
    RemembranceToken.destroy_all
  end
  
  config.extend(ClassHelpers)
  config.include(InstanceHelpers)
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

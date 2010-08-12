def add_load_path(path)
  path = File.expand_path(File.join("..", path), __FILE__)
  $LOAD_PATH.unshift path
  ActiveSupport::Dependencies.autoload_paths.unshift path
  ActiveSupport::Dependencies.autoload_once_paths.unshift path
end

# Add mock paths to load paths
add_load_path "mocks/models"
add_load_path "../app/models"
#add_load_path "../app/lib"
add_load_path "../app/controllers"

$LOAD_PATH.uniq!
ActiveSupport::Dependencies.autoload_paths.uniq!
ActiveSupport::Dependencies.autoload_once_paths.uniq!

undef add_load_path

def column(name)
  ActiveRecord::ConnectionAdapters::Column.new(name, nil)
end

begin
  require 'genspec'
rescue LoadError
  puts " >> Missing gem: 'genspec' <<"
  puts 
  puts "These specs rely on genspec, which tests the project's generators."
  puts
  raise
end

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |fi| require fi }
#gem 'genspec', '0.2.0.prerails3.2'

RSpec.configure do |config|
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
  config.include(Rails.application.routes.url_helpers)
end

def error_on(model, key, value = nil, options = {})
  instance = model.new()
  instance.send("#{key}=", value)
  options.each { |k,v| instance.send("#{k}=", v) }
  
  instance.valid?
  e = instance.errors[key.to_s]
  
  # The specs were written to test for Rails 2 errors, and this more or less converts the Rails 3 ones for Rails 2
  # compatibility.
  #
  # TODO: Update the specs for Rails 3, and let the R2 spec helper deal with compatibility.
  if e.size < 2
    return e.shift
  else
    e
  end
end

require 'rspec/rails'

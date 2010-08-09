class Auth::Generators::ConfigurationGenerator < Rails::Generator::Base
  attr_reader :model
  
  def initialize(args, options = {})
    super(args, options)
  end
  
  def manifest
    record do |m|
      m.directory "lib/tasks"
      m.directory "config/initializers"
      m.file "tasks/migrations.rb", "lib/tasks/sparkly_migration.rb"
      m.file 'initializer.rb', 'config/initializers/sparkly_authentication.rb'
    end
  end
  
  def spec
    @spec ||= Rails::Generator::Spec.new("configuration", File.join(Auth.path, "auth/generators"), nil)
  end
end

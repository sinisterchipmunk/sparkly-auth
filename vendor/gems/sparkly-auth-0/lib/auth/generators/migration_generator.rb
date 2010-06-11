class Auth::Generators::MigrationGenerator < Rails::Generator::NamedBase
  attr_reader :model
  
  def initialize(model, options = {})
    @model = model
    args = [ model.name ]
    super(args, options)
  end
  
  def manifest
    record do |m|
      m.migration_template "create_sparkly_passwords.rb", "db/migrate", :migration_file_name => "create_sparkly_passwords"
      
      #m.migration_template 'migration.rb', 'db/migrate', :migration_file_name => "add_sparkles_to_#{table_name}"
    end
  end
  
  def table_name
    model && model.target ? model.target.table_name : super
  end
  
  def spec
    @spec ||= Rails::Generator::Spec.new("migration", File.join(Auth.path, "auth/generators"), nil)
  end
end

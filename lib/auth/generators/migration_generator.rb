class Auth::Generators::MigrationGenerator < Rails::Generator::NamedBase
  attr_reader :model
  
  def initialize(model, options = {})
    @model = model
    args = [ model.name ]
    super(args, options)
  end
  
  def manifest
    record do |m|
      m.directory "db/migrate"
      mg_version = 0
      Auth.behavior_classes.each do |behavior|
        behavior.migrations.each do |file_name|
          fn_with_ext = file_name[/\.([^\.]+)$/] ? file_name : "#{file_name}.rb"
          mg_version += 1
          mg_version_s = mg_version.to_s.rjust(3, '0')
          m.template File.join("migrations", fn_with_ext), File.join("db/migrate/#{mg_version_s}_#{fn_with_ext}")
        end
      end
    end
  end
  
  def table_name
    model && model.target ? model.target.table_name : super
  end
  
  def spec
    @spec ||= Rails::Generator::Spec.new("sparkly_migration", File.join(Auth.path, "auth/generators"), nil)
  end
end

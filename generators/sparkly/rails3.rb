require 'rails/generators'

class SparklyGenerator < Rails::Generators::NamedBase
  class << self
    def source_root
      File.join(File.dirname(__FILE__), "templates")
    end
  end
  
  def do_generation
    method_name = "gen_#{file_name.pluralize}"
    if private_methods.collect { |m| m.to_s }.include?(method_name)  # why doesn't respond_to? work?!
      send method_name
    else
      puts "(not found: #{method_name})"
      gen_helps
    end
  end
  
  private
  def gen_controllers
    each_model do |model|
      @model = model
      template "accounts_controller.rb", File.join("app/controllers", "#{model.accounts_controller.underscore}_controller.rb"),
                 :assigns => { :model => model }
      template "sessions_controller.rb", File.join("app/controllers", "#{model.sessions_controller.underscore}_controller.rb"),
                 :assigns => { :model => model }
      
      template "accounts_helper.rb", File.join("app/helpers", "#{model.accounts_controller.underscore}_helper.rb"),
                 :assigns => { :model => model }
      template "sessions_helper.rb", File.join("app/helpers", "#{model.sessions_controller.underscore}_helper.rb"),
                 :assigns => { :model => model }
      
    end

    # Controller generator should also kick off the corresponding view generation.
    gen_views
  end
  
  def gen_helps # yeah, yeah...
    copy_file 'help_file.txt', 'doc/sparkly_authentication.txt'
    readme 'help_file.txt'
  end
  
  def gen_configs
    copy_file "tasks/migrations.rb", "lib/tasks/sparkly_migration.rb"
    copy_file 'initializer.rb', 'config/initializers/sparkly_authentication.rb'
  end
  
  def gen_migrations
    mg_version = 0
    Auth.behavior_classes.each do |behavior|
      behavior.migrations.each do |file_name|
        fn_with_ext = file_name[/\.([^\.]+)$/] ? file_name : "#{file_name}.rb"
        mg_version += 1
        mg_version_s = mg_version.to_s.rjust(3, '0')
        template File.join("migrations", fn_with_ext), File.join("db/migrate/#{mg_version_s}_#{fn_with_ext}")
      end
    end
  end
  
  def gen_views
    each_model do |model|
      @model = model
      resource_directory = File.join("app/views", model.accounts_controller.underscore)
      sessions_directory = File.join("app/views", model.sessions_controller.underscore)
        
      %w(edit new show).each do |f|
        copy_file "views/sparkly_accounts/#{f}.html.erb", File.join(resource_directory, "#{f}.html.erb")
      end
        
      copy_file "views/sparkly_sessions/new.html.erb", File.join(sessions_directory, "new.html.erb")
    end
  end
  
  def models
    Auth.configuration.authenticated_models
  end
  
  def each_model(&block)
    models.each &block
  end
  
=begin
  def controllers(m)
    spawn_model_generator(m, Auth::Generators::ControllersGenerator)
  end
  
  def routes(m)
    spawn_model_generator(m, Auth::Generators::RouteGenerator)
  end
  
  def views(m)
    spawn_model_generator(m, Auth::Generators::ViewsGenerator)
  end
  
  def migrations(m)
  end
  
  def config(m)
    spawn_generator(m, Auth::Generators::ConfigurationGenerator, [])
  end
  
  def spawn_model_generator(manifest, type)
    each_model do |model|
      spawn_generator(manifest, type, model)
    end
  end
  
  def spawn_generator(manifest, type, args)
    generator = type.new(args, spawned_generator_options)
    generator.manifest.replay(manifest)
  end
  
  def each_model(&block)
    Auth.configuration.authenticated_models.each &block
  end
  
  def nameless_type?
    nameless_types.include? @type
  end
  
  def nameless_types
    %w(migrations config help views controllers)
  end
  
  def spawned_generator_options
    options.merge(:source => File.join(source_root), :destination => destination_root)
  end
=end
end

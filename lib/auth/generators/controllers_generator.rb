class Auth::Generators::ControllersGenerator < Rails::Generator::NamedBase
  attr_reader :model
  
  def initialize(model, options = {})
    @model = model
    args = [ model.name ]
    super(args, options)
  end
  
  def manifest
    record do |m|
      m.directory "app/controllers"
      m.directory "app/helpers"
      
      m.template "accounts_controller.rb", File.join("app/controllers", "#{model.accounts_controller.underscore}_controller.rb"),
                 :assigns => { :model => model }
      m.template "sessions_controller.rb", File.join("app/controllers", "#{model.sessions_controller.underscore}_controller.rb"),
                 :assigns => { :model => model }
      
      m.template "accounts_helper.rb", File.join("app/helpers", "#{model.accounts_controller.underscore}_helper.rb"),
                 :assigns => { :model => model }
      m.template "sessions_helper.rb", File.join("app/helpers", "#{model.sessions_controller.underscore}_helper.rb"),
                 :assigns => { :model => model }
      
      # Controller generator should also kick off the corresponding view generation.
      views = Auth::Generators::ViewsGenerator.new(model, :source => File.join(source_root), :destination => destination_root)
      views.manifest.replay(m)
    end
  end
  
  def spec
    @spec ||= Rails::Generator::Spec.new("controllers", File.join(Auth.path, "auth/generators"), nil)
  end
end

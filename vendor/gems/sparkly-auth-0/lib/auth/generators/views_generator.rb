class Auth::Generators::ViewsGenerator < Rails::Generator::NamedBase
  attr_reader :model
  
  def initialize(model, options = {})
    @model = model
    args = [ model.name ]
    super(args, options)
  end
  
  def manifest
    record do |m|
      m.directory resource_directory = File.join("app/views", model.accounts_controller.underscore)
      m.directory sessions_directory = File.join("app/views", model.sessions_controller.underscore)
      
      %w(edit new show).each do |f|
        m.file "views/sparkly_accounts/#{f}.html.erb", File.join(resource_directory, "#{f}.html.erb")
      end
      
      m.file "views/sparkly_sessions/new.html.erb", File.join(sessions_directory, "new.html.erb")
    end
  end
  
  def spec
    @spec ||= Rails::Generator::Spec.new("views", File.join(Auth.path, "auth/generators"), nil)
  end
end

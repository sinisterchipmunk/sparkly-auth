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
      
      resource_directory = File.join("app/views", model.accounts_controller.underscore)
      sessions_directory = File.join("app/views", model.sessions_controller.underscore)
      
      base = File.join(source_root, "views/sparkly_accounts")
      Dir[File.join(base, "**/*")].each do |fi|
        fi.gsub!(/^#{Regexp::escape base}/, '')
        m.file(File.join("views/sparkly_accounts", fi), File.join(resource_directory, fi))
      end

      base = File.join(source_root, "views/sparkly_sessions")
      Dir[File.join(base, "**/*")].each do |fi|
        fi.gsub!(/^#{Regexp::escape base}/, '')
        m.file(File.join("views/sparkly_sessions", fi), File.join(sessions_directory, fi))
      end
    end
  end
  
  def spec
    @spec ||= Rails::Generator::Spec.new("views", File.join(Auth.path, "auth/generators"), nil)
  end
end

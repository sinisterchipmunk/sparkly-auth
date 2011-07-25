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
      
      views = File.join(source_root, 'views')
      Dir[File.join(views, "sparkly_{accounts,sessions}/{rails2,common}/**/*")].each do |fi|
        next unless File.file?(fi)
        relative = fi.gsub(/^#{Regexp::escape views}\/sparkly_(accounts|sessions)\/(rails2|common)\/?/, '')
        dest = case $1
          when "accounts" then resource_directory
          when "sessions" then sessions_directory
          else raise "unexpected value: #{$1}"
        end
        m.file fi.sub(/^#{Regexp::escape source_root}\/?/, ''),
               File.join(dest, relative).sub(/^#{Regexp::escape source_root}\/?/, '')
      end
    end
  end
  
  def spec
    @spec ||= Rails::Generator::Spec.new("views", File.join(Auth.path, "auth/generators"), nil)
  end
end

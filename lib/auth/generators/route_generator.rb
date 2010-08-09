class Auth::Generators::RouteGenerator < Rails::Generator::NamedBase
  attr_reader :model
  
  def initialize(model, options = {})
    @model = model
    args = [ model.name ]
    super(args, options)
  end
  
  def manifest
    record do |m|
      m.route_resources plural_name
    end
  end
  
  def spec
    @spec ||= Rails::Generator::Spec.new("route", File.join(Auth.path, "auth/generators"), nil)
  end
end

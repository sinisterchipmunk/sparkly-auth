# This file sets up the various include paths and whatnot that would have been set up
# for us by Rails if this were a Rails plugin.

base_path = File.expand_path(File.join(File.dirname(__FILE__), '..'))

%w(lib app/controllers app/models).each do |path|
  path = File.join(base_path, path)
  $LOAD_PATH << path
  ActiveSupport::Dependencies.load_paths << path
  ActiveSupport::Dependencies.load_once_paths << path
end

ActionController::Base.view_paths << File.join(base_path, 'app/views')

# Routes
ActionController::Routing::Routes.add_configuration_file(File.join(base_path, "rails/routes.rb"))

require File.expand_path(File.join(File.dirname(__FILE__), "../lib/dependencies"))
require File.expand_path(File.join(File.dirname(__FILE__), "../lib/auth"))

unless ActiveSupport::Dependencies.load_paths.include?(Auth.path)
  $LOAD_PATH << Auth.path
  ActiveSupport::Dependencies.load_paths << Auth.path
  ActiveSupport::Dependencies.load_once_paths << Auth.path
end

# Kick auth after initialize and do it again before every request in development
Rails.configuration.to_prepare do
  Auth.kick!
end

require File.join(File.dirname(__FILE__), "hacks/rails2")

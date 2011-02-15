# This file sets up the various include paths and whatnot that would have been set up
# for us by Rails if this were a Rails plugin.

base_path = File.expand_path(File.join(File.dirname(__FILE__), '..'))
def add_to_load_path(path, load_once = false)
  load_paths = ActiveSupport::Dependencies.respond_to?(:autoload_paths) ? ActiveSupport::Dependencies.autoload_paths : ActiveSupport::Dependencies.load_paths
  load_once_paths = ActiveSupport::Dependencies.respond_to?(:autoload_once_paths) ? ActiveSupport::Dependencies.autoload_once_paths : ActiveSupport::Dependencies.load_once_paths

  $LOAD_PATH << path
  load_paths << path
  if load_once
    load_once_paths << path
  else
    load_once_paths.delete path
  end
end

add_to_load_path File.join(base_path, 'app/controllers'), false
add_to_load_path File.join(base_path, 'app/models'), false
add_to_load_path Auth.path, true

ActionController::Base.view_paths << File.join(base_path, 'app/views')

# Routes
ActionController::Routing::Routes.add_configuration_file(File.join(base_path, "rails/routes.rb"))

Rails.configuration.gem "sc-core-ext", :version => ">= 1.2.1"
require File.expand_path(File.join(File.dirname(__FILE__), "../lib/auth"))


undef add_to_load_path

# Register the built-in behaviors before the auth config initializer has run. In Rails3 this is in a before_initialize
# block.
require_dependency File.join(File.dirname(__FILE__), "../lib/auth/builtin_behaviors")

# Kick auth after initialize and do it again before every request in development
Rails.configuration.to_prepare do
  Auth.kick! unless Auth.defer_kickstart?
end

require File.join(File.dirname(__FILE__), "hacks/rails2")

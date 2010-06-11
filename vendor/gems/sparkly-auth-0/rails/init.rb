# This file sets up the various include paths and whatnot that would have been set up
# for us by Rails if this were a Rails plugin.

base_path = File.expand_path("../..", __FILE__)

Rails.configuration.controller_paths << File.join(base_path, "app/controllers")
Rails.configuration.load_paths << File.join(base_path, 'lib')
Rails.configuration.load_paths << File.join(base_path, 'app/models')

ActionController::Base.view_paths << File.join(base_path, 'app/views')

# Routes
ActionController::Routing::Routes.add_configuration_file(File.join(base_path, "rails/routes.rb"))


# Finally, we're ready to load the app as if it were a plugin.
require File.expand_path("../../init", __FILE__)

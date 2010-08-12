require 'rails'
gem "sc-core-ext", :require_as => ["sc-core-ext", "sc-core-ext"]
require File.expand_path(File.join(File.dirname(__FILE__), '../auth'))

module Auth
  class Engine < Rails::Engine
    paths.lib             << File.join(Auth.path)
    paths.app.controllers << File.join(Auth.path, "../app/controllers")
    paths.app.helpers     << File.join(Auth.path, '../app/helpers')
    paths.app.models      << File.join(Auth.path, "../app/models")
    paths.app.views       << File.join(Auth.path, "../app/views")
    paths.config.routes   << File.join(Auth.path, "../rails/routes_rails3.rb")
    
    config.autoload_paths << Auth.path
    config.autoload_once_paths << Auth.path
    
    generators do
      require File.join(File.dirname(__FILE__), '../../generators/sparkly/sparkly_generator')
    end
    
    rake_tasks do
      load File.join(File.dirname(__FILE__), 'tasks/migrations.rb')
    end

    config.before_initialize do
      require_dependency File.join(File.dirname(__FILE__), "builtin_behaviors")
    end
    
    config.to_prepare do
      Auth.kick! unless Auth.defer_kickstart?
    end
  end
end

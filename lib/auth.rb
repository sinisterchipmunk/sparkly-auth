require 'sc-core-ext'

module Auth
  class << self
    public :delegate
    delegate :encryptor, :default_accounts_controller_name, :default_sessions_controller_name,
             :password_update_frequency, :base_controller, :login_required_message, :logout_required_message,
             :default_destination, :session_duration, :invalid_credentials_message, :login_successful_message,
             :logout_message, :session_timeout_message, :default_login_path, :account_deleted_message,
             :account_created_message, :account_updated_message, :account_locked_message, :max_login_failures,
             :generate_routes?, :disable_route_generation!, :password_uniqueness_message,
             :password_history_length, :base_controller_name, :account_lock_duration,
             :password_format, :password_format_message, :minimum_password_length, :behaviors, :behavior_classes,
             :to => :configuration

    def routing_proc
      proc do
        Auth.configuration.authenticated_models.each do |model|
          catch :missing do
            begin
              model.name # if an error is going to occur due to missing model, it'll happen here.
            rescue NameError
              # we rescue silently because the user's already been warned (during startup).
              throw :missing
            end

            resource model.name.underscore, :model => model.name,
                     :controller => model.accounts_controller do
              resource :session, :controller => model.sessions_controller, :model => model.name
              match '/login', :to => "#{model.sessions_controller}#new", :as => "login"
              match '/logout', :to => "#{model.sessions_controller}#destroy", :as => "logout"
            end
          end
        end
      end
    end
    
    def configuration
      @configuration ||= Auth::Configuration.new
    end
    
    def configure
      yield configuration
    end
    
    def defer_kickstart?
      @defer_kickstart ||= !!ENV['DEFER_SPARKLY']
    end
    
    def defer_kickstart=(a)
      @defer_kickstart = !!a
    end
    
    def path
      if @configuration
        @configuration.path
      else
        File.dirname(__FILE__)
      end
    end
    
    # Applies all configuration settings. This is done by the Auth system after it has been configured but before
    # it processes any requests.
    def configure!
      begin
        configuration.apply!
      rescue NameError
        puts
        puts "WARNING: #{$!.message}"
        puts
        puts "This happened while trying to configure Sparkly Authentication."
        puts "You should verify that /config/initializers/sparkly_authentication.rb"
        puts "is set up properly. It could be that you just haven't created the"
        puts "model yet. If so, this error will disappear when the model exists."
        puts
        if ENV['AUTH_BACKTRACE']
          puts $!.backtrace
        else
          puts "(Run with AUTH_BACKTRACE=true to see a full bactrace.)"
        end
        puts
      end
    end
    
    # Useful for cleaning up after tests, but probably not much else.
    def reset_configuration!
      @configuration = Auth::Configuration.new
    end
    
    alias_method :kick!, :configure!
  end
end

if defined?(Rails) && Rails::VERSION::MAJOR == 3
  # Rails 3 doesn't load rails/init.rb first, so we need to do that ourselves.
  require File.join(File.dirname(__FILE__), "../rails/init")
end

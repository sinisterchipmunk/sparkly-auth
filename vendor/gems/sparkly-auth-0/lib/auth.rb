module Auth
  class << self
    public :delegate
    delegate :path, :encryptor, :default_accounts_controller_name, :default_sessions_controller_name,
             :password_update_frequency, :base_controller, :login_required_message, :logout_required_message,
             :default_destination, :session_duration, :invalid_credentials_message, :login_successful_message,
             :logout_message, :session_timeout_message, :default_login_path, :account_deleted_message,
             :account_created_message, :account_updated_message, :account_locked_message, :max_login_failures,
             :generate_routes?, :disable_route_generation!, :password_uniqueness_message,
             :password_history_length, :base_controller_name, :account_lock_duration,
             :password_format, :password_format_message, :minimum_password_length, :behaviors, :behavior_classes,
             :to => :configuration
    
    def configuration
      @configuration ||= Auth::Configuration.new
    end
    
    def configure
      yield configuration
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
      end
    end
    
    # Useful for cleaning up after tests, but probably not much else.
    def reset_configuration!
      @configuration = Auth::Configuration.new
    end
    
    alias_method :kick!, :configure!
  end
end

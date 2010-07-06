module Auth
  class Configuration
    include Auth::BehaviorLookup
    
    class << self
      include Auth::BehaviorLookup

      def behavior_configs
        @behavior_configs ||= []
      end
      
      def register_behavior(name)
        behavior_class = lookup_behavior(name)
        # If the behavior has a configuration, add an instance of it to self.
        accessor_name = name
        name = "#{behavior_class.name}::Configuration"
        behavior_configs << [ accessor_name, name.constantize ]
        Auth.class.delegate accessor_name, :to => :configuration
      rescue NameError
        # Presumably, the behavior does not have a configuration.
      end
    end

    # IS there a better way to do this?? I'm dying to find it...
    Dir[File.join(File.dirname(__FILE__), "behavior/*.rb")].each do |fi|
      unless fi[/\/base.rb$/]
        const_name = fi.gsub(/^#{Regexp::escape File.dirname(__FILE__)}\/behavior\/(.*)\.rb$/, '\1')
        register_behavior(const_name)
      end
    end

    # Regular expression which passwords must match. The default forces at least 1
    # uppercase, lowercase and numeric character.
    attr_accessor :password_format
  
    # When the password to be created does not conform to the above format, this error
    # message will be shown.
    attr_accessor :password_format_message
  
    # Minimum length for passwords.
    attr_accessor :minimum_password_length
    
    # The path to the Sparkly Auth libraries.
    attr_reader :path
    
    # The array of Auth::Model instances which represent the models which will be authenticated.
    # See also #authenticate
    attr_accessor :authenticated_models
    
    # The array of behaviors which will be applied by default to every authenticated model. If
    # a behavior set is specified for a given model, it will be used instead of (not in addition to)
    # this array.
    attr_accessor :behaviors
    
    # How frequently should passwords be forced to change? Nil for never.
    attr_accessor :password_update_frequency
    
    # The class to use for encryption of passwords. This can be any class, as long as it responds
    # to #encrypt and #matches?
    attr_accessor :encryptor
    
    # The name of the controller to route to for creating users, editing them, etc.
    attr_accessor :default_accounts_controller_name
    
    # The name of the controller to route to for logging in, logging out, etc.
    attr_accessor :default_sessions_controller_name
    
    # The message to display when the user is not allowed to view a page because s/he must log in.
    attr_accessor :login_required_message
    
    # The message to display when the user is not allowed to view a page because s/he must log out.
    attr_accessor :logout_required_message
    
    # The NAME of the controller to use as a base controller. All Sparkly controllers will subclass
    # this, and methods such as current_user will be added to it. Defaults to 'application'.
    attr_accessor :base_controller_name
    
    # If an issue would prevent the user from viewing the current page, Auth will redirect the user
    # to the value stored in session[:destination]. If this value is not set, then Auth will default
    # to this path.
    attr_accessor :default_destination
    
    # The maximum session duration. Users will be logged out automatically after this period expires.
    attr_accessor :session_duration
    
    # Message to display if username and/or password were incorrect.
    attr_accessor :invalid_credentials_message
    
    # Message to display if login was successful.
    attr_accessor :login_successful_message
    
    # Message to display when user logs out.
    attr_accessor :logout_message
    
    # Message to display when the user's session times out due to inactivity.
    attr_accessor :session_timeout_message
    
    # The method to call in order to determine which resource to use when implicitly logging in.
    #   Default:
    #     :new_user_session_path
    # If set to nil, the #default_destination will be used instead.
    attr_accessor :default_login_path
    
    # The message to display when the user deletes his or her account.
    attr_accessor :account_deleted_message
    
    # The message to display when the user creates an account.
    attr_accessor :account_created_message
    
    # The message to display when user profile has been updated or the password has been changed.
    attr_accessor :account_updated_message
    
    # The message to display if an account has been locked.
    attr_accessor :account_locked_message
    
    # The length of time an account is locked for, if it is locked.
    attr_accessor :account_lock_duration
    
    # The maximum login attempts permitted before an account is locked. Set to nil to disable locking.
    attr_accessor :max_login_failures
    
    # The message to display when password change matches one of the previous passwords
    attr_accessor :password_uniqueness_message

    # The number of passwords to keep in the password change history for each user. Any given
    # user may not use the same password twice for at least this duration. For instance, if
    # set to 4, then a user must change his password 4 times before s/he can reuse one of
    # his/her previous passwords.
    attr_accessor :password_history_length
    
    # Finds the controller with the same name as #base_controller_name and returns it.
    def base_controller
      "#{base_controller_name.to_s.camelize}Controller".constantize
    rescue NameError => err
      begin
        base_controller_name.to_s.camelize.constantize
      rescue NameError
        raise err
      end
    end
    
    # Returns the classes which represent each behavior listed in #behaviors
    def behavior_classes
      behaviors.collect { |behavior| lookup_behavior(behavior) }
    end
    
    # Causes Sparkly Auth to *not* generate routes by default. You'll have to map them yourself if you disable
    # route generation.
    def disable_route_generation!
      @generate_routes = false
    end
    
    # Returns true if Sparkly Auth is expected to generate routes for this application. This is true by
    # default, and can be disabled with #disable_route_generation!
    def generate_routes?
      @generate_routes
    end
    
    def initialize
      @password_format = /(^(?=.*\d)(?=.*[a-zA-Z]).{7,}$)/
      @password_format_message = "must contain at least 1 uppercase, 1 lowercase and 1 number"
      @minimum_password_length = 7
      @path = File.expand_path(File.join(File.dirname(__FILE__), '..'))
      @authenticated_models = Auth::TargetList.new
      @behaviors = [ :core ]
      @password_update_frequency = 30.days
      @encryptor = Auth::Encryptors::Sha512
      @password_uniqueness_message = "must not be the same as any of your recent passwords"
      @password_history_length = 4
      @default_accounts_controller_name = "sparkly_accounts"
      @default_sessions_controller_name = "sparkly_sessions"
      @login_required_message = "You must be logged in to view this page."
      @logout_required_message = "You must be logged out to view this page."
      @invalid_credentials_message = "Login credentials were not valid."
      @login_successful_message = "Signed in successfully."
      @default_destination = "/"
      @base_controller_name = 'application'
      @session_duration = 30.minutes
      @logout_message = "You have been signed out."
      @session_timeout_message = "You have been signed out due to inactivity. Please sign in again."
      @default_login_path = :new_user_session_path
      @account_deleted_message = "Your account has been deleted."
      @account_created_message = "Your account has been created."
      @account_updated_message = "Your changes have been saved."
      @account_locked_message = "Account is locked due to too many invalid attempts"
      @account_lock_duration = 30.minutes
      @max_login_failures = 5
      @generate_routes = true
      
      self.class.behavior_configs.each do |accessor_name, config_klass|
        instance_variable_set("@#{accessor_name}", config_klass.new(self))
        singleton = (class << self; self; end)
        singleton.send(:define_method, accessor_name) { instance_variable_get("@#{accessor_name}") }
      end
    end
    
    def apply!
      # Apply options to authenticated models
      authenticated_models.each do |model|
        model.apply_options!
      end
    end
    
    # Accepts a list of model names (or the models themselves) and an optional set of options which
    # govern how the models will be authenticated.
    #
    # Examples:
    #   Auth.configure do |config|
    #     config.authenticate :user
    #     config.authenticate :admin, :key => :login
    #     config.authenticate :user, :admin, :with => /a password validating regexp/
    #   end
    #
    # Note that if an item is specified more than once, the options will be merged together for the
    # entry. For instance, in the above example, the :user model will be authenticated with :password,
    # while the :admin model will be authenticated with :password on key :login.
    #
    def authenticate(*model_names) 
      options = model_names.extract_options!
      model_names.flatten.each do |name|
        if model = authenticated_models.find(name)
          model.merge_options! options
        else
          authenticated_models << Auth::Model.new(name, options)
        end
      end
    end
    
    # Returns the configuration for the given authenticated model.
    def for_model(name_or_class_or_instance)
      name_or_class = name_or_class_or_instance
      name_or_class = name_or_class.class if name_or_class.kind_of?(ActiveRecord::Base)
      authenticated_models.find(name_or_class)
    end
    
    private
  end
end

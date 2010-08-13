module Auth
  class Configuration
    include Auth::BehaviorLookup
    delegate :configuration_keys, :to => 'self.class'
    
    # The array of Auth::Model instances which represent the models which will be authenticated.
    # See also #authenticate
    attr_accessor :authenticated_models
    
    include Auth::Configuration::Keys

    class << self
      include Auth::BehaviorLookup

      def add_option_delegator_for(key)
        define_method :"#{key}_with_option_delegation=" do |value|
          res = send("#{key}_without_option_delegation=", value)
          authenticated_models.each { |model| model.set_default_option(key, value) }
          res
        end

        alias_method_chain :"#{key}=", :option_delegation
      end
      
      def add_configuration_key_with_delegation(*keys)
        keys = keys.flatten
        eig = class << Auth; self; end
        eig.instance_eval { delegate *[keys, {:to => :configuration}].flatten }
        add_configuration_key_without_delegation(*keys)
      end
      
      def attr_accessor_with_delegator(*keys)
        result = attr_accessor_without_delegator(*keys)
        keys.flatten.each { |key| add_option_delegator_for(key) }
        result
      end

      def attr_writer_with_delegator(*keys)
        result = attr_writer_without_delegator(*keys)
        keys.flatten.each { |key| add_option_delegator_for(key) }
        result
      end
      
      alias_method_chain :add_configuration_key, :delegation
      alias_method_chain :attr_writer,   :delegator
      alias_method_chain :attr_accessor, :delegator

      def behavior_configs
        @behavior_configs ||= []
        @behavior_configs
      end
      
      def register_behavior(name, behavior_class = lookup_behavior(name))
        # If the behavior has a configuration, add it to self.
        accessor_name = name
        name = "#{behavior_class.name}::Configuration"
        # we do this so that we can raise NameError now, not later.
        behavior_configs << [ accessor_name, name.constantize.name ]
        # eg Auth.remember_me.something = 5
        Auth.class.delegate accessor_name, :to => :configuration
      rescue NameError
        # Presumably, the behavior does not have a configuration.
      end
    end
    
    # The message to display when the user creates an account.
    #
    # Default:
    #  "Your account has been created."
    attr_accessor :account_created_message
    
    # The message to display when the user deletes his or her account.
    #
    # Default:
    #  "Your account has been deleted."
    attr_accessor :account_deleted_message
    
    # The message to display when user profile has been updated or the password has been changed.
    #
    # Default:
    #  "Your changes have been saved."
    attr_accessor :account_updated_message
    
    # The length of time an account is locked for, if it is locked.
    #
    # Default:
    #  30.minutes
    attr_accessor :account_lock_duration
    
    # The message to display if an account has been locked.
    #
    # Default:
    #  "Account is locked due to too many invalid attempts."
    attr_accessor :account_locked_message
    
    # The NAME of the controller to use as a base controller. All Sparkly controllers will subclass
    # this, and methods such as current_user will be added to it. Defaults to 'application'.
    #
    # Default:
    #  'application'
    attr_accessor :base_controller_name
    
    # The array of behaviors which will be applied by default to every authenticated model. If
    # a behavior set is specified for a given model, it will be used instead of (not in addition to)
    # this array.
    #
    # Default:
    #  [ :core ]
    attr_accessor :behaviors
    
    # The name of the controller to route to for creating users, editing them, etc.
    #
    #  "sparkly_accounts"
    attr_accessor :default_accounts_controller_name
    
    # If an issue would prevent the user from viewing the current page, Auth will redirect the user
    # to the value stored in session[:destination]. If this value is not set, then Auth will default
    # to this path.
    #
    # Default:
    #  "/"
    attr_accessor :default_destination
    
    # The method to call in order to determine which resource to use when implicitly logging in.
    #
    # If set to nil, the #default_destination will be used instead.
    #
    # Default:
    #  :new_user_session_path
    attr_accessor :default_login_path
    
    # The name of the controller to route to for logging in, logging out, etc.
    #
    # Default: 
    #  "sparkly_sessions"
    attr_accessor :default_sessions_controller_name
    
    # The class to use for encryption of passwords. This can be any class, as long as it responds
    # to #encrypt and #matches?
    #
    # Default:
    #  Auth::Encryptors::Sha512
    attr_accessor :encryptor
    
    # Message to display if username and/or password were incorrect.
    #
    # Default:
    #  "Credentials were not valid."
    attr_accessor :invalid_credentials_message
    
    # If true, the user will be automatically logged in after registering a new account.
    # Note that this can be modified by some behaviors.
    #
    # Default:
    #  true
    attr_accessor :login_after_signup
  
    # The message to display when the user is not allowed to view a page because s/he must log in.
    #
    # Default:
    #  "You must be signed in to view this page."
    attr_accessor :login_required_message
    
    # Message to display if login was successful.
    #
    # Default:
    #  "Signed in successfully."
    attr_accessor :login_successful_message
    
    # Message to display when user logs out.
    #
    # Default:
    #  "You have been signed out."
    attr_accessor :logout_message
    
    # The message to display when the user is not allowed to view a page because s/he must log out.
    #
    #  "You must be signed out to view this page."
    attr_accessor :logout_required_message
    
    # The maximum login attempts permitted before an account is locked. Set to nil to disable locking.
    #
    # Default:
    #  5
    attr_accessor :max_login_failures
    
    # Minimum length for passwords.
    #
    # Default:
    #  7
    attr_accessor :minimum_password_length
    
    # Regular expression which passwords must match. The default forces at least 1
    # uppercase, lowercase and numeric character.
    # 
    # Default:
    #  /(^(?=.*\d)(?=.*[a-zA-Z]).{7,}$)/
    attr_accessor :password_format
  
    # When the password to be created does not conform to the above format, this error
    # message will be shown.
    #
    # Default:
    #  "must contain at least 1 uppercase, 1 lowercase and 1 number"
    attr_accessor :password_format_message
  
    # The number of passwords to keep in the password change history for each user. Any given
    # user may not use the same password twice for at least this duration. For instance, if
    # set to 4, then a user must change his password 4 times before s/he can reuse one of
    # his/her previous passwords.
    #
    # Default:
    #  4
    attr_accessor :password_history_length
    
    # The message to display when password change matches one of the previous passwords
    #
    # Default:
    #  "must not be the same as any of your recent passwords"
    attr_accessor :password_uniqueness_message

    # How frequently should passwords be forced to change? Nil for never.
    #
    # Default:
    #  30.days
    attr_accessor :password_update_frequency
    
    # The path to the Sparkly Auth libraries.
    attr_reader :path
    
    # The maximum session duration. Users will be logged out automatically after this period expires.
    #
    # Default:
    #  30.minutes
    attr_accessor :session_duration
    
    # Message to display when the user's session times out due to inactivity.
    #
    # Default:
    #  "You have been signed out due to inactivity. Please sign in again."
    attr_accessor :session_timeout_message
    
    def behavior=(*args, &block) #:nodoc:
      send(:behaviors=, *args, &block)
    end
    
    # Finds the controller with the same name as #base_controller_name and returns it.
    def base_controller
      "#{base_controller_name.to_s.camelize}Controller".constantize
    rescue NameError => err
      begin
        base_controller_name.to_s.camelize.constantize
      rescue NameError
        # reraise the original error because '_controller' should have been omitted by convention. Also,
        # the backtrace will be more useful.
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
    
    # this was documented as an accessor, but is expected to always be an Array.
    def behaviors_with_conversion_to_array=(*args) #:nodoc:
      self.behaviors_without_conversion_to_array = args.flatten
    end
    alias_method_chain :behaviors=, :conversion_to_array
    
    def initialize
      @password_format = /(?=[-_a-zA-Z0-9]*?[A-Z])(?=[-_a-zA-Z0-9]*?[a-z])(?=[-_a-zA-Z0-9]*?[0-9])[-_a-zA-Z0-9]{7,}/
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
      @login_required_message = "You must be signed in to view this page."
      @logout_required_message = "You must be signed out to view this page."
      @invalid_credentials_message = "Credentials were not valid."
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
      @account_locked_message = "Account is locked due to too many invalid attempts."
      @account_lock_duration = 30.minutes
      @max_login_failures = 5
      @generate_routes = true
      @login_after_signup = false
      
      self.class.behavior_configs.each do |accessor_name, config_klass|
        instance_variable_set("@#{accessor_name}", config_klass.constantize.new(self))
        singleton = (class << self; self; end)
        singleton.send(:define_method, accessor_name) { instance_variable_get("@#{accessor_name}") }
      end
    end
    
    def apply!
      # all configurations are now applied through Auth::Model. If no models are being authenticated,
      # then no authentication should be possible -- so what is there to apply?
      
      # Apply options to authenticated models
      authenticated_models.each do |model|
        model.apply_options!
      end
    end
    
    def to_hash_with_subconfigs #:nodoc:
      self.class.behavior_configs.inject(to_hash_without_subconfigs) do |hash, (accessor_name, constant_name)|
        hash[accessor_name.to_sym] = send(accessor_name)
        hash
      end
    end
    alias_method_chain :to_hash, :subconfigs
    
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
          authenticated_models << Auth::Model.new(name, options, to_hash)
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

module Auth
  module Behavior
    # Adds the most basic authentication behavior to registered models. Passwords have the following
    # validations added:
    #   - uniqueness of :secret, :scope => [ :authenticatable_type, :authenticatable_id ]
    #   - presence of :secret
    #   - format of :secret ("must be at least 7 characters with at least 1 uppercase, 1 lowercase and 1 number")
    #   - confirmation of :secret, if secret has changed
    #   - presence of :secret_confirmation, if secret has changed
    #
    # Additionally, the following methods are added:
    #   #expired?
    # 
    # The authenticated model(s) will have the following methods added to them:
    #   #password_expired?
    #
    class Core < Auth::Behavior::Base
      migration "create_sparkly_passwords"
      
      def apply_to_controller(base_controller, user_model)
        base_controller.send(:include, Auth::Behavior::Core::ControllerExtensions)
      end
      
      def apply_to_password(password_model, user_model)
        config = user_model.sparkly_config
        password_model.instance_eval do
          belongs_to :authenticatable, :polymorphic => true
          
          validates_length_of :unencrypted_secret, :minimum => config.minimum_password_length,
                              :message => "must be at least #{config.minimum_password_length} characters",
                              :if => :secret_changed?
          validates_format_of :unencrypted_secret, :with => config.password_format, :allow_blank => true,
                       :message => config.password_format_message,
                       :if => :secret_changed?
                                          
          validates_presence_of :secret
          validates_confirmation_of :secret, :if => :secret_changed?
          validates_presence_of :secret_confirmation, :if => :secret_changed?
          validates_presence_of :persistence_token
          validates_uniqueness_of :persistence_token, :if => :persistence_token_changed?
          attr_protected :secret, :secret_confirmation
          include Auth::Behavior::Core::PasswordMethods
          
          validate do |password|
            password.errors.rename_attribute("unencrypted_secret", "secret")
          end
          
          if Rails::VERSION::MAJOR == 3
            # The hooks have changed.
            after_initialize :after_initialize
          end
        end
      end
      
      def apply_to_user(model)
        model_config = model.sparkly_config
        model_config.target.instance_eval do
          has_many :passwords, :dependent => :destroy, :as => :authenticatable, :autosave => true
          
          attr_protected :password, :password_confirmation
          validates_presence_of sparkly_config.key
          validates_uniqueness_of sparkly_config.key
          validates_presence_of :password
  
          include Auth::Behavior::Core::AuthenticatedModelMethods
  
          if Rails::VERSION::MAJOR == 3
            # The hooks have changed.
            after_save :after_save
          end

          validate do |account|
            account.errors.rename_attribute("passwords.secret", "password")
            account.errors.rename_attribute("passwords.secret_confirmation", "password_confirmation")

            # the various salts make it impossible to do this:
            #   validates_uniqueness_of :secret, :scope => [ :authenticatable_type, :authenticatable_id ],
            #                           :message => config.password_uniqueness_message
            # so we have to do it programmatically.
            if account.password_changed?
              secret = account.password_model.unencrypted_secret
              account.passwords.each do |password|
                unless password.new_record? # unless it's the one we're creating
                  if password.matches?(secret)
                    account.errors.add(:password, sparkly_config.password_uniqueness_message)
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

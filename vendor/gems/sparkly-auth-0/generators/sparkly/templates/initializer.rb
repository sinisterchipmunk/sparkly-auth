# This file is what sets up Sparkly Auth to work properly with Rails. It was generated
# by "script/generate sparkly config" and can be regenerated with that command, though 
# you may not want to actually do that if you've made changes to this file.
#
# ***
# The ONLY thing you really need to look at is which models to authenticate; by default
# there's only one, and by default that one is User, so if you're happy with that then
# you're done.
# ***
#
# The rest of this file is littered with comments and settings. All of the settings
# mirror Sparkly Auth's own internal defaults; in other words, you can safely delete
# the remainder of this file without breaking anything. The options here are mostly
# shown as examples for you to override, if you need to do so.
#
# You are also encouraged to check out the Sparkly Auth RDoc documentation for more
# information regarding configuration options. The classes of interest in this case are
# Auth::Configuration and Auth::Model.

Auth.configure do |config|
  config.authenticate :user
    # Adds a model to be authenticated. See the Auth::Model class for information on
    # what options you can pass. Here are some common examples:
    #  
    #   config.authenticate :user, :accounts_controller => "users", :sessions_controller => "user_sessions"
    #   config.authenticate :user, :key => "login"
    #
    # By default, :key is "email" and the controllers are Sparkly's internal controllers.
    # (Don't forget you can also script/generate controllers or script/generate views to
    # remove the overhead of setting up your own.)
  
  config.default_login_path = :new_user_session_path
    # This is the name of a method accessible to the controller, such as :new_user_session_path.
    #
    # When a user attempts to access a protected resource, they will be redirected *somewhere*.
    # If this option is set, it'll call the method by the referenced name, and redirect the
    # user to whatever path is returned.
    #
    # If this option is NOT set, then the user will simply be redirected to
    # config.default_destination.
  
  #config.disable_route_generation!
    # By default, routes are generated for your authenticated resources automatically by
    # Sparkly Auth. If you wish to disable this so that you can map your own routes,
    # just uncomment the line above.
  
  config.behaviors = [:core]
    # Used when you wish to extend Auth's base functionality with your own, or replace
    # it entirely (by removing :core).
  
  config.password_history_length = 4
    # The number of passwords to keep in the password change history for each user. Any given
    # user may not use the same password twice for at least this duration. For instance, if
    # set to 4, then a user must change his password 4 times before s/he can reuse one of
    # his/her previous passwords.
  
  config.password_uniqueness_message = "must not be the same as any of your recent passwords"
    # The message to show if the password matches one of the previous passwords
  
  config.password_update_frequency = 30.days
    # How often should Sparkly Auth force the user to update his or her password? Set to
    # nil for "never".
  
  config.encryptor = Auth::Encryptors::Sha512
    # How to encrypt the password.
  
  config.default_accounts_controller_name = "sparkly_accounts"
    # The *name* of the controller to use for creating, editing and showing account details.
    # This can be overridden by sending an :accounts_controller option to #authenticate,
    # as above.
  
  config.default_sessions_controller_name = "sparkly_sessions"
    # The *name* of the controller to use for logging in and logging out.
    # This can be overridden by sending a :sessions_controller option to #authenticate,
    # as above.  
  
  config.default_destination = "/"
    # When the controllers attempt to redirect, and they don't know where else to go, they'll
    # send the user here.
  
  config.base_controller = ApplicationController
    # The controller to be extended by SparklyController. Also, this is the controller
    # that will be imbued with helpers such as #current_user.
  
  config.session_duration = 30.minutes
    # How long can the user be inactive before being signed out automatically? Set to nil
    # for "forever".
  
  config.max_login_failures = 5
    # This is how many times the user may attempt to log in before their account is locked.
    # Set to nil for 'never'.
  
  config.account_lock_duration = 30.minutes
    # If the user's account becomes locked due to too many failed login attempts, this is
    # how long the user will have to wait before trying again.
    

  # Various messages to be shown in the response.
  config.login_required_message = "You must be signed in to view this page."
  config.logout_required_message = "You must be signed out to view this page."
  config.invalid_credentials_message = "Credentials were not valid."
  config.login_successful_message = "Signed in successfully."
  config.logout_message = "You have been signed out."
  config.session_timeout_message = "You have been signed out due to inactivity. Please sign in again."
  config.account_deleted_message = "Your account has been deleted."
  config.account_created_message = "Your account has been created."
  config.account_updated_message = "Your changes have been saved."
  config.account_locked_message = "Account is locked due to too many invalid attempts"
end

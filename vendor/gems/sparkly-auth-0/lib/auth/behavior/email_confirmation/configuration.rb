class Auth::Behavior::EmailConfirmation::Configuration
  attr_reader :configuration
  attr_reader :login_denied_message
  
  def apply!
    AuthenticatableObserver.instance
  end
  
  def enabled?
    configuration.behaviors.include?(:email_confirmation)
  end
  
  def initialize(configuration)
    @configuration = configuration
    @login_denied_message = "Login denied: user has not yet been confirmed. Please check your email."
  end
end

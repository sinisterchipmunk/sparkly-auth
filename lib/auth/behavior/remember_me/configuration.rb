class Auth::Behavior::RememberMe::Configuration
  # Message to be displayed in flash[:error] when a likely theft of the remember token has been detected.
  #
  # Default:
  #  "Your account may have been hijacked recently! Verify that all settings are correct."
  attr_accessor :token_theft_message
  
  # How long can a user stay logged in?
  #
  # Default:
  #  6.months
  attr_accessor :duration
  
  # Provides a handle back to the root configuration object.
  attr_reader :configuration
  
  # Returns true if the root configuration object's behaviors include :remember_me.
  def enabled?
    configuration.behaviors.include? :remember_me
  end
  
  def initialize(configuration)
    @configuration = configuration
    @token_theft_message = "Your account may have been hijacked recently! Verify that all settings are correct."
    @duration = 6.months
  end
end

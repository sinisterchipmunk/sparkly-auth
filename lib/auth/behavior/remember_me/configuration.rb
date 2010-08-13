class Auth::Behavior::RememberMe::Configuration < Auth::Behavior::Base::Configuration
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
  
  def defaults!
    @token_theft_message = "Your account may have been hijacked recently! Verify that all settings are correct."
    @duration = 6.months
  end
end

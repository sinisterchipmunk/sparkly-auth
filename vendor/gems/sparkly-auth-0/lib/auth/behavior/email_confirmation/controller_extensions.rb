module Auth::Behavior::EmailConfirmation::ControllerExtensions
  # If a :remember option is given, a remembrance cookie will be set. If omitted, the cookie will be, too.
  def login_with_confirmation!(user, options = {})
  #    # This should never happen in production, but it helps with my specs because it's tricky to reload the affected
  #    # classes reliably.
  #    return login_without_confirmation!(user, options) if !user.password_model.respond_to?(:confirmed)
  #    
    if user.password_model.confirmed
      login_without_confirmation!(user, options)
    else
      flash[:error] = Auth.email_confirmation.login_denied_message
    end
  end

  def self.included(base)
    base.class_eval do
      hide_action :login_with_confirmation!, :login_without_confirmation!
      
      unless method_defined?(:login_without_confirmation!)
        #alias_method_chain :login!, :confirmation
      end
    end
  end
end

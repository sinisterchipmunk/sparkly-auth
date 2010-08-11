module Auth::Behavior::RememberMe::ControllerExtensions
  # If a :remember option is given, a remembrance cookie will be set. If omitted, the cookie will be, too.
  def login_with_remembrance!(user, options = {})
    puts 'login with remembrance'
    login_without_remembrance!(user)
    
    if options[:remember]
      token = RemembranceToken.create!(:authenticatable => user)
      set_remembrance_token_cookie(token)
    end
  end
  
  # If a :forget option is given, the remembrance cookie will also be deleted.
  def logout_with_remembrance!(options = {})
    logout_without_remembrance!
    if options[:forget]
      cookies.delete(:remembrance_token)
    end
  end

  def authenticate_current_user_with_remembrance
    authenticate_current_user_without_remembrance
    if @current_user == false
      authenticate_with_remembrance_token
    end
  end
  
  def authenticate_with_remembrance_token
    if token_value = cookies[:remembrance_token]
      token = RemembranceToken.find_by_value(token_value)
      if token
        @current_user = token.authenticatable
        handle_remembrance_token_theft(token) if token.theft?
        token.regenerate
        token.save
        set_remembrance_token_cookie(token)
      end
    end
  end
  
  def handle_remembrance_token_theft(token)
    flash[:error] = Auth.remember_me.token_theft_message
    token.authenticatable.remembrance_tokens.destroy_all
  end
  
  def set_remembrance_token_cookie(token)
    cookies[:remembrance_token] = {
      :value => token.value,
      :expires => Auth.remember_me.duration.from_now
    }
  end

  def self.included(base)
    base.class_eval do
      hide_action :login_with_remembrance!, :login_without_remembrance!, :authenticate_current_user_without_remembrance,
                  :authenticate_current_user_with_remembrance, :authenticate_with_remembrance_token,
                  :set_remembrance_token_cookie, :handle_remembrance_token_theft, :logout_with_remembrance!,
                  :logout_without_remembrance!
      
      unless method_defined?(:login_without_remembrance!)
        alias_method_chain :login!, :remembrance
        alias_method_chain :logout!, :remembrance
        alias_method_chain :authenticate_current_user, :remembrance
      end
    end
  end
end

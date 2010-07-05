module Auth::Behavior::Core::ControllerExtensions::CurrentUser
  def self.included(base)
    base.send(:hide_action, :current_user_from_session, :timeout_current_session, :authenticate_with_persistence_token,
              :authenticate_with_single_access_token, :authenticate_with_session_cookie, :authenticate_current_user)
  end
  
  def current_user
    return @current_user unless @current_user.nil?
    @current_user = false
    authenticate_current_user
    @current_user
  end
  
  def authenticate_current_user
    if session && session[:session_token]
      authenticate_with_session_cookie
    elsif params && params[:single_access_token] # single access token, useful for WS APIs
      authenticate_with_single_access_token
    end
  end
  
  def authenticate_with_session_cookie
    if Auth.session_duration.nil? || session[:active_at] > Auth.session_duration.ago
      authenticate_with_persistence_token
    else
      timeout_current_session
    end
  end
  
  def authenticate_with_single_access_token
    # There is no session duration because this works per-request.
    password = Password.find_by_single_access_token(params[:single_access_token], :include => :authenticatable)
    @current_user = password.authenticatable if password
  end
  
  def authenticate_with_persistence_token
    password =  Password.find_by_persistence_token(session[:session_token], :include => :authenticatable)
    if password
      @current_user = password.authenticatable
      login! @current_user # to refresh session timeout
    else
      # Something weird happened and the user's password data can no longer be found. Log him out to prevent
      # anything else from going wrong.
      logout!
    end
  end
  
  def timeout_current_session
    logout!
    # We'll put the message in the notice, but if the current page requires a login, the flash will be over
    # written. That's where @session_timeout_message comes in.
    flash[:notice] = @session_timeout_message = Auth.session_timeout_message
  end
end

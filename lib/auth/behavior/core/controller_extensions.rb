module Auth::Behavior::Core::ControllerExtensions
  def self.included(base)
    base.instance_eval do
      include Auth::Behavior::Core::ControllerExtensions::CurrentUser
      extend Auth::Behavior::Core::ControllerExtensions::ClassMethods
      helper_method :new_session_path, :current_user
      hide_action :current_user, :find_current_session, :require_login, :require_logout, :login!, :logout!,
                  :redirect_back_or_default, :new_session_path, :store_location
    end
  end
  
  def require_login                                    
    unless current_user
      store_location
      flash[:notice] = @session_timeout_message || Auth.login_required_message
      login_path = Auth.default_login_path ? send(Auth.default_login_path) : Auth.default_destination
      redirect_to login_path
    end
  end
  
  def store_location(url = request.request_uri)
    session[:destination] = url
  end
  
  def require_logout
    redirect_back_or_default Auth.default_destination, Auth.logout_required_message if current_user
  end
  
  # Forcibly logs in the current client as the specified user.
  #
  # The options hash is unused, and is reserved for other behaviors to make use of.
  # For instance, the "remember me" behavior checks for a :remember option and, if true, sets a remembrance token
  # cookie.
  def login!(user, options = {})
    session[:session_token] = user.persistence_token
    session[:active_at] = Time.now
    @current_user = user
  end
  
  # Forcibly logs out the current client.
  #
  # The options hash is unused, and is reserved for other behaviors to make use of.
  #
  def logout!(options = {})
    session[:session_token] = session[:active_at] = nil
  end
  
  def redirect_back_or_default(path, notice = nil)
    flash[:notice] = notice if notice
    redirect_to session.delete(:destination) || path
  end
end

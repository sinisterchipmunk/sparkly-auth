module Auth::Extensions::Controller
  def self.included(base)
    base.instance_eval do
      helper_method :new_session_path
      hide_action :current_user, :find_current_session, :require_login, :require_logout, :login!, :logout!,
                  :redirect_back_or_default, :new_session_path, :store_location
      
      class << self
        def require_login_for(*actions)
          before_filter :require_login, actions.extract_options!.merge(:only => actions)
        end
  
        def require_logout_for(*actions)
          before_filter :require_logout, actions.extract_options!.merge(:only => actions)
        end
      end
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
  
  def current_user
    @current_user = false unless @current_user
    if session[:session_token]
      if session[:active_at] > Auth.session_duration.ago
        @current_user = Password.find_by_persistence_token(session[:session_token], :include => :authenticatable)
        @current_user = @current_user.authenticatable if @current_user
        login! @current_user # to refresh session timeout
      else
        logout!
        # We'll put the message in the notice, but if the current page requires a login, the flash will be over
        # written. That's where @session_timeout_message comes in.
        flash[:notice] = @session_timeout_message = Auth.session_timeout_message
      end
    end
    @current_user
  end
  
  # Forcibly logs in the current client as the specified user.
  def login!(user)
    session[:session_token] = user.persistence_token
    session[:active_at] = Time.now
  end
  
  # Forcibly logs out the current client.
  def logout!
    session[:session_token] = session[:active_at] = nil
  end
  
  def redirect_back_or_default(path, notice = nil)
    flash[:notice] = notice if notice
    redirect_to session.delete(:destination) || path
  end
end

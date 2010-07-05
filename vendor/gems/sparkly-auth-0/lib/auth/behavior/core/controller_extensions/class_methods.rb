module Auth::Behavior::Core::ControllerExtensions::ClassMethods
  def require_login_for(*actions)
    before_filter :require_login, actions.extract_options!.merge(:only => actions)
  end
  
  def require_logout_for(*actions)
    before_filter :require_logout, actions.extract_options!.merge(:only => actions)
  end

  def require_login(*args)
    before_filter :require_login, *args
  end

  def require_logout(*args)
    before_filter :require_logout, *args
  end

  alias_method :requires_login,   :require_login
  alias_method :require_user,     :require_login
  alias_method :requires_user,    :require_login
  alias_method :requires_logout,  :require_logout
  alias_method :require_no_user,  :require_logout
  alias_method :requires_no_user, :require_logout
end
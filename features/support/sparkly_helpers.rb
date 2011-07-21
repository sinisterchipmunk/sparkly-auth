def logged_in?
  if respond_to?(:controller) && controller
    (!!controller.current_user)
  else
    !!(session[:session_token] && session[:active_at] rescue false) # can raise NoMethodError if there's no request
  end
end

def current_user
  controller.send(:current_user)
end

def cookie(name)
  cookies[name]
end

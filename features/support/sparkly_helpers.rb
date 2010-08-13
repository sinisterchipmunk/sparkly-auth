#def verify_user_exists!(email, password)
#  User.find_by_email(email).should be_nil # I had some generic users show up in the test DB. Drove me nuts.
#  
#  user = User.new(:email => email)
#  user.password = password
#  user.password_confirmation = password
#  user.save!
#  user
#end

def logged_in?
  if respond_to?(:controller) && controller
    (!!controller.current_user)
#  elsif (respond_to?(:response) && response rescue false) # Rails3/RSpec2 raises 'No response yet. Request a page first.'
#    (!!response.template.controller.current_user)
  else
    !!(session[:session_token] && session[:active_at] rescue false) # can raise NoMethodError if there's no request
  end
end

def current_user
  controller.send(:current_user)
end

def cookie(name)
  cookies[name]
#  if response && response.respond_to?(:template)
#    response.template.controller.send(:cookies)[:remembrance_token].should_not be_blank
#  else
#    
end

# no idea why I need this
module RedirectWTF
  def handle_redirect!
    while redirect? || response.body =~ /You are being .*?redirected/
      follow_redirect!
    end
  end  
end

World(RedirectWTF)

def verify_user_exists!(email, password)
  User.count.should == 0 # I had two generic users show up in the test DB. Drove me nuts.
  
  returning(User.new(:email => email)) { |user|
    user.password = password
    user.password_confirmation = password
    user.save!
  }
end

def logged_in?
  if respond_to?(:response) && response
    (!!response.template.controller.current_user)
  elsif respond_to?(:controller) && controller
    (!!controller.current_user)
  else
    !!(session[:session_token] && session[:active_at])
  end
end

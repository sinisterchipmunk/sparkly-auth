class SparklySessionsController < SparklyController
  # GET new_model_session_url
  def new
  end

  # POST model_session_url
  def create
    if session[:locked_out_at] && session[:locked_out_at] > Auth.account_lock_duration.ago
      flash[:error] = Auth.account_locked_message
      render :action => 'new'
      return
    end
    
    model = model_class.find(:first, :conditions => { model_config.key => model_params[model_config.key] },
                             :include => :passwords)
    
    if model && model.password_matches?(model_params[:password])
      login! model, :remember => remember_me?
      redirect_back_or_default Auth.default_destination, Auth.login_successful_message
    else
      session[:login_failures] = session[:login_failures].to_i + 1
      if Auth.max_login_failures && session[:login_failures] >= Auth.max_login_failures
        session[:locked_out_at] = Time.now
        flash[:error] = Auth.account_locked_message
      else
        flash[:error] = Auth.invalid_credentials_message
      end
      render :action => "new"
    end
  end

  # DELETE model_session_url
  def destroy
    logout!(:forget => true)
    redirect_back_or_default Auth.default_destination, Auth.logout_message
  end
  
  private
  # Uncomment if you don't trust the params[:model] set up by Sparkly routing, or if you've
  # disabled them.
  #
  #def model_name
  #  "User"
  #end

  def remember_me?
    remembrance = model_params[:remember_me]
    if remembrance.kind_of?(String)
      return false if remembrance.blank?
      return remembrance.to_i != 0
    elsif remembrance.kind_of?(Numeric)
      return remembrance != 0
    else
      return remembrance
    end
  end
end

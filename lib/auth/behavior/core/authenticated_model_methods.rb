module Auth::Behavior::Core::AuthenticatedModelMethods
  def self.included(base)
    base.instance_eval do
      delegate :persistence_token, :single_access_token, :perishable_token, :to => :password_model
    end
  end
  
  def password_expired?
    passwords.empty? || passwords.last.created_at < sparkly_config.password_update_frequency.ago
  end
      
  def password_model
    passwords.empty? || @new_password ? new_password : passwords.last
  end
  
  def password_required?
    new_record? || passwords.empty? || passwords.last.secret.blank?
  end
  
  def password_matches?(phrase)
    password_model.matches?(phrase)
  end
  
  def password
    password_model.secret
  end
  
  def password=(value)
    new_password.secret = value
  end
  
  def password_confirmation=(value)
    new_password.secret_confirmation = value
  end
  
  def password_confirmation
    password_model.secret_confirmation
  end
  
  def password_changed?
    password_model.new_record? || password_model.secret_changed?
  end
  
  def after_save
    @new_password = nil
    # clear out old passwords so we're conforming to Auth.password_history_length
    while passwords.length > Auth.password_history_length
      passwords.shift.destroy
    end
  end
  
  private
  def new_password
    @new_password ||= begin
      p = Password.new
      passwords << p
      p
    end
  end
end

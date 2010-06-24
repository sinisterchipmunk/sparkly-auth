class Auth::Behavior::Base
#  cattr_accessor :global_validation
#  cattr_accessor :local_validation
#  self.global_validation ||= []
#  self.local_validation  ||= []
  
  def apply_to(model)    
    if model.respond_to?(:ancestors) && model.ancestors && model.ancestors.include?(Password)
      track_behavior(model) { apply_to_passwords!(model) }
    else
      track_behavior(model.target) { apply_to_accounts!(model) }
    end
  end

  def apply_to_passwords!(password_model)
    raise NotImplementedError, "Be sure to override #apply_to_passwords!(passwords_model) in your Auth Behavior"
  end
  
  def apply_to_accounts!(model_config)
    raise NotImplementedError, "Be sure to override #apply_to_accounts!(model_config) in your Auth Behavior"
  end
  
  private
  def track_behavior(model)
    if !behavior_tracked?(model)
      track_behavior!(model)
      yield
    end
  end  

  def behavior_tracked?(model)
    behavior_tracker(model).include? behavior_name  
  end
    
  def track_behavior!(model)
    behavior_tracker(model) << behavior_name
  end
  
  def behavior_tracker(model)
    model.instance_variable_get("@__behavior_tracker") || model.instance_variable_set("@__behavior_tracker", [])
  end
  
  def behavior_name
    self.class.name
  end

  public
  class << self
    # The trackers that maintain whether a model has already had a particular behavior added to it will also
    # cause the behavior NOT to be added when the models are reloaded in development. This method is a hook
    # for the application reloader to essentially clear the related arrays, making those models eligible for
    # addition once more.
    def reset_registrations!
      #(global_validation + local_validation).each { |v| v[:registered].clear }
    end
    
    def apply_to(model)
      behavior = new
      behavior.apply_to(Password)
      behavior.apply_to(model)
    end
  end
end

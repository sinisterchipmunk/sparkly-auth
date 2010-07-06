class Auth::Behavior::Base
  class_inheritable_array :migrations
  read_inheritable_attribute(:migrations) || write_inheritable_attribute(:migrations, [])
  
  def apply_to(model)    
    if model.respond_to?(:ancestors) && model.ancestors && model.ancestors.include?(Password)
      track_behavior(model) { apply_to_passwords(model) }
    else
      track_behavior(model.target) { apply_to_accounts(model) }
    end
  end
  
  def apply_to_controllers(model_config)
    # Add additional methods to ApplicationController (or whatever controller Sparkly is told to use)
    Auth.base_controller.send(:include, "#{self.class.name}::ControllerExtensions".constantize)
    # why this doesn't work in cuke?
#    if (container = self.class).const_defined?(:ControllerExtensions)
#      Auth.base_controller.send(:include, container.const_get(:ControllerExtensions))
#    end
  rescue NameError
  end

  def apply_to_passwords(password_model)
    raise NotImplementedError, "Be sure to override #apply_to_passwords(passwords_model) in your Auth Behavior"
  end
  
  def apply_to_accounts(model_config)
    raise NotImplementedError, "Be sure to override #apply_to_accounts(model_config) in your Auth Behavior"
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
    def apply_to(model)
      behavior = new
      behavior.apply_to(Password)
      behavior.apply_to(model)
      behavior.apply_to_controllers(model)
    end
    
    # Declares a migration template for a behavior. If sourcedir is given, it will be used as the location
    # in which to find the template.
    def migration(filename)
      migrations << filename unless migrations.include?(filename)
    end
  end
end

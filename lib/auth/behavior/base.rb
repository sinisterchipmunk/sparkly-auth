class Auth::Behavior::Base
  #unloadable
  
  class_inheritable_array :migrations
  read_inheritable_attribute(:migrations) || write_inheritable_attribute(:migrations, [])
  
  def apply(model = nil)
    if model
      track_behavior(model.target) do
        apply_to_accounts(model)
        apply_to_passwords(Password)
      end
    end
    
    track_behavior(base = Auth.base_controller) do
      apply_to_controllers(base)
    end
  end
  
  alias_method :apply_to, :apply
  
  def apply_to_controllers(base_controller)
    be_sure_to_override("apply_to_controllers(base_controller)")
  end

  def apply_to_passwords(password_model)
    be_sure_to_override("apply_to_passwords(password_model)")
  end
  
  def apply_to_accounts(model_config)
    be_sure_to_override("apply_to_accounts(model_config)")
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
  
  private
  def be_sure_to_override(name)
    raise NotImplementedError, "Be sure to override ##{name} in #{self.class.name}"
  end

  public
  class << self
    # Declares a migration template for a behavior. If sourcedir is given, it will be used as the location
    # in which to find the template.
    def migration(filename)
      migrations << filename unless migrations.include?(filename)
    end
    
#    def inherited(base)
#      base.instance_eval { unloadable } # is this necessary?
#    end
  end
end

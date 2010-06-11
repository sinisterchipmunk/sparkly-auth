class SparklyController < (Auth.base_controller)
  helper_method :model_class, :model_instance, :model_name, :model, :model_path, :new_model_path, :edit_model_path,
                :model_config, :model_session_path, :model_params
  before_filter :find_user_model

  protected
    attr_accessor :model_instance
    
    def find_user_model
      self.model_instance = current_user || model_class.new()
    end
    
    def model_class
      model_name.constantize
    end
    
    def model_name
      params[:model]
    end
    
    def model_path
      send("#{model_name.underscore}_path")
    end
    
    def new_model_path
      send("new_#{model_name.underscore}_path")
    end
    
    def edit_model_path
      send("edit_#{model_name.underscore}_path")
    end
  
    def model_session_path
      send("#{model_name.underscore}_session_path")
    end
    
    def model_config
      Auth.configuration.for_model(model_name)
    end
  
    def model_params
      params[model_name.underscore] || {}
    end
  
    alias_method :model, :model_instance  
end
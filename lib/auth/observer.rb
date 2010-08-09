class Auth::Observer < ActiveRecord::Observer
  public :add_observer!
  
  class << self
    # Attaches the observer to the supplied model classes.
    def observe(*models)
      models.flatten!
      models.collect! { |model| model.is_a?(Symbol) ? model.to_s.camelize.constantize : model }
      observed_classes.concat models
      observed_classes.uniq!
    end
    
    def observed_classes
      @observed_classes ||= []
    end
  end
  
  def observed_classes
    Set.new(self.class.observed_classes)
  end
end
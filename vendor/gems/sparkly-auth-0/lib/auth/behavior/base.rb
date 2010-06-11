class Auth::Behavior::Base
  cattr_accessor :global_validation
  cattr_accessor :local_validation
  self.global_validation ||= []
  self.local_validation  ||= []
  
  class << self
    # The trackers that maintain whether a model has already had a particular behavior added to it will also
    # cause the behavior NOT to be added when the models are reloaded in development. This method is a hook
    # for the application reloader to essentially clear the related arrays, making those models eligible for
    # addition once more.
    def reset_registrations!
      (global_validation + local_validation).each { |v| v[:registered].clear }
    end
    
    def apply_to(model)
      apply_validation(global_validation, model, :instance_eval)
      apply_validation(local_validation,  model, :validate)
    end
    
#    def migration(name = :_no_assn)
#      @migration = name unless name == :_no_assn
#      @migration
#    end
    
    def validate_all(type, &block)
      global_validation << validation_descriptor(type, block)
    end
    
    def validate(type, &block)
      local_validation << validation_descriptor(type, block)
    end
    
    private
    def apply_validation(validation, model, method)
      validation.each do |valid|
        if !valid[:registered].include?(model)
          plural = valid[:type].pluralize.underscore
          if plural == "passwords"
            Password.send(method, &valid[:block])
            valid[:registered] << model
          elsif plural == "authenticated_models" || plural == model.name.pluralize.underscore || plural == model.table_name
            model.target.send(method, &valid[:block])
            valid[:registered] << model
          end
        end
      end
    end
    
    def validation_descriptor(type, block)
      { :type => type.to_s, :block => block, :registered => [] }
    end
  end
end

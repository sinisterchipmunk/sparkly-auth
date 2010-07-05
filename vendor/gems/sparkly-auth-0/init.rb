require File.expand_path("../dependencies", __FILE__)
require File.expand_path("../lib/auth", __FILE__)

$LOAD_PATH << Auth.path
ActiveSupport::Dependencies.load_paths << Auth.path
ActiveSupport::Dependencies.load_once_paths << Auth.path
#ActiveSupport::Dependencies.load_once_paths.delete(Auth.path)

Rails.configuration.after_initialize do
  Auth.kick!
end

ActionController::Dispatcher.instance_eval do
  class << self
    define_method :reload_application_with_sparkles do
      returning reload_application_without_sparkles do
        Auth.kick!
      end
    end
    
    alias_method_chain :reload_application, :sparkles
  end
end

# FIXME HACK extension to ActiveRecord::Errors to allow error attributes to be renamed. This is
# because otherwise we'll end up producing very confusing error messages complaining about :secret,
# :encrypted_secret, and so forth when all the user really cares about is :password.
class ActiveRecord::Errors
  def rename_attribute(original_name, new_name)
    original_name, new_name = original_name.to_s, new_name.to_s
    return if original_name == new_name
    
    @errors.each do |attribute, old_errors|
      if attribute.to_s == original_name
        original_name = attribute # because some are strings, some are symbols.
        
        old_errors.each do |error|
          new_error = error.dup
          new_error.attribute = new_name
          unless @errors[new_name] && @errors[new_name].include?(new_error)
            @errors[new_name] ||= []
            @errors[new_name] << new_error
          end
        end
        @errors.delete(original_name)
      end
    end
  end
end

class ActiveRecord::Error
  def ==(other)
    other.kind_of?(ActiveRecord::Error) && attribute.to_s == other.attribute.to_s && message == other.message
  end
end
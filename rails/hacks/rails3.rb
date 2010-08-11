# Extension to ActiveRecord::Errors to allow error attributes to be renamed. This is
# because otherwise we'll end up producing very confusing error messages complaining about :secret,
# :encrypted_secret, and so forth when all the user really cares about is :password.
#
# This is mainly for backward compatibility to Rails 2.3, where we had to hack such things into AR.
class ActiveModel::Errors
  def rename_attribute(original_name, new_name)
    # Rails2 used strings so the app at large may be using strings. We use Symbols in Rails 3 though, apparently.
    original_name.kind_of?(String) && original_name = original_name.to_sym
    new_name.kind_of?(String) && new_name = new_name.to_sym
    
    if key?(original_name)
      new_value = delete(original_name)
      self[new_name].concat new_value.flatten
    end

    # avoid doubles
    self[new_name].uniq!
    
    self
  end
end

require 'spec_helper'

# Extension to ActiveRecord::Errors to allow error attributes to be renamed. This is
# because otherwise we'll end up producing very confusing error messages complaining about :secret,
# :encrypted_secret, and so forth when all the user really cares about is :password.
#
# This is mainly for backward compatibility to Rails 2.3, where we had to hack such things into AR.
describe "Hacks: AR::Errors#rename_attributes" do
  def errors_on(key)
    if Rails::VERSION::MAJOR == 3
      errors[key]
    else
      case e = errors.on(key)
        when nil then []
        when Array then e
        else [e]
      end
    end
  end
  
  def errors; subject; end
  
  subject do
    errors =
      if Rails::VERSION::MAJOR == 3
        ActiveModel::Errors.new(Password.new)
      else
        ActiveRecord::Errors.new(Password.new)
      end
    
    errors.add(:unencrypted_secret, "must be unique")
    errors.add(:password, "must be longer")
    errors
  end
  
  it "should rename once" do
    errors.rename_attribute(:unencrypted_secret, :secret)
    errors_on(:secret).should == ["must be unique"]
  end
  
  it "should rename twice" do
    errors.rename_attribute(:unencrypted_secret, :secret)
    errors.rename_attribute(:secret, :password)
    
    # order agnostic, else we'd use x.should == ["...","..."]
    errors_on(:password).should include("must be unique")
    errors_on(:password).should include("must be longer")
  end
end

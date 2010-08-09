require 'spec_helper'

describe Auth do
  it "should be configurable" do
    Auth.should respond_to(:configuration)
    Auth.configure do |config|
      config.path.should_not be_blank
    end
  end
  
  it "should provide a default encryptor" do
    Auth.encryptor.should_not be_nil
  end
  
  it "should allow classes to be designated 'authenticated models'" do
    Auth.configure do |config|
      config.authenticate :user
    end
  end
  
  it "should merge options for multiple entries as long as they resolve to the same class" do
    Auth.configure do |config|
      config.authenticate :user, :key => :login
      config.authenticate :user, :with => :password
    end
    
    Auth.configuration.authenticated_models.find(:user).options.without(:behaviors).should == {
      :key => :login,
      :with => :password
    }
  end
end

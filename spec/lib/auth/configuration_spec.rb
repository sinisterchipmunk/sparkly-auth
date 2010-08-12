# The majority of the configuration object is transient and is tested between auth_spec and the behaviors.

require 'spec_helper'

describe Auth::Configuration do
  it "should have #configuration_keys" do
    subject.configuration_keys.should_not be_empty
  end
  
  context "given a single behavior" do
    before(:each) { subject.behaviors = :core }
    
    it "should return an array" do
      subject.behaviors.should == [:core]
    end
  end
  
  context "with an authenticated model" do
    before(:each) { subject.authenticate :user }
    
    it "should have a password update frequency option" do
      subject.authenticated_models.first.options.keys.should include(:password_update_frequency)
    end
    
    it "should use the default password frequency in the model options" do
      subject.authenticated_models.first.options[:password_update_frequency].should == 30.days
    end
    
    context "and a single behavior" do
      before(:each) { subject.behavior = :core }
      
      it "should return an array" do
        subject.authenticated_models.first.behaviors.should == [:core]
      end
    end
    
    context "and two behaviors" do
      before(:each) { subject.behaviors = :core, :remember_me }
      
      it "should use both behaviors in the authenticated model" do
        subject.authenticated_models.first.behaviors.should == [:core, :remember_me]
      end
    end
    
    context "and a password update frequency" do
      before(:each) { subject.password_update_frequency = 60.days }
      
      it "should use the high level password frequency in the model options (because it lacks an overriding setting)" do
        subject.authenticated_models.first.options[:password_update_frequency].should == 60.days
      end
      
      context "followed by an overridden password update frequency" do
        before(:each) { subject.password_update_frequency = 90.days }
        
        it "should use the most recent level password frequency in the model options (because it lacks an overriding setting)" do
          subject.authenticated_models.first.options[:password_update_frequency].should == 90.days
        end
      end
    end
  end
end

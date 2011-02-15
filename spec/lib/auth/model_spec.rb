require 'spec_helper'

describe Auth::Model do
  context "given nonexisting model name" do
    subject { Auth::Model.new(:nonexisting_user, :behaviors => [:core]) }
    
    it "should fail silently during initialization because it might not have been generated yet" do
      proc { subject }.should_not raise_error
    end
  end

  context "with default options" do
    subject { Auth::Model.new(:user, :behaviors => [:core]) }
    
    before(:each) do
      reload!
      subject.apply_options!
    end

    it "should validate presence of :email on User" do
      error_on(User, :email).should == "can't be blank"
    end
    
    it "should use :core behavior" do
      subject.behaviors.should include(:core)
    end
  end
  
  context "with an empty :behaviors option" do
    subject { Auth::Model.new(:user, :behaviors => []) }
    before(:each) do
      reload!
      subject.apply_options!
    end
    it "should have no behaviors" do subject.behaviors.should be_empty end
  end
  
  context "with a hash for :with option" do
    subject { Auth::Model.new(:user, :behaviors => [:core], :with => {
            :secret => :passwd,
            :format => /^.{8}$/,
            :message => "must be exactly 8 characters"
    })}
    
    before(:each) do
      reload!
      subject.apply_options!
    end
    
    it "should validate presence of :email on User" do
      error_on(User, :email).should == "can't be blank"
    end
  end
end

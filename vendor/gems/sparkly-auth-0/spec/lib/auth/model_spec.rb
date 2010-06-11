require 'spec_helper'

describe Auth::Model do
  before(:each) do
    Password.stub!(:columns).and_return([column("secret"), column("authenticatable_type"),
                                         column("authenticatable_id")])
  end
  
  context "given nonexisting model name" do
    subject { Auth::Model.new(:nonexisting_user) }
    
    it "should fail silently during initialization because it might not have been generated yet" do
      proc { subject }.should_not raise_error
    end
  end
  
  context "with default options" do
    subject { Auth::Model.new(:user) }
    
    before(:each) do
      User.stub!(:columns).and_return([column("email")])
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
    before(:each) { subject.apply_options! }
    it "should have no behaviors" do subject.behaviors.should be_empty end
  end
  
  context "with a hash for :with option" do
    subject { Auth::Model.new(:user, :with => {
            :secret => :passwd,
            :format => /^.{8}$/,
            :message => "must be exactly 8 characters"
    })}
    
    before(:each) do
      User.stub!(:columns).and_return([column("email")])
      subject.apply_options!
    end
    
    it "should validate presence of :email on User" do
      error_on(User, :email).should == "can't be blank"
    end
  end
end

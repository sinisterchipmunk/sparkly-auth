require 'spec_helper'

describe "Behavior: Core" do
  subject { Auth::Model.new(:user, :behaviors => [:core], :password_update_frequency => 30.days) }
  
  before(:each) do
    subject.apply_options!
  end
  
  context "user" do
    it "should not be able to reuse a previous password" do
      u = User.new(:email => "generic1@example.com")
      u.password = u.password_confirmation = "Generic12"
      u.save!
      u.password = u.password_confirmation = "Generic13"
      u.save!
      u.password = u.password_confirmation = "Generic12"
      
      proc { u.save! }.should raise_error(ActiveRecord::RecordInvalid)
    end
    
    it "should produce multiple password models" do
      u = User.new(:email => "generic2@example.com")
      u.password = u.password_confirmation = "Generic12"
      u.save!
      u.password = u.password_confirmation = "Generic13"
      u.save!
      
      u.passwords.length.should == 2
    end
    
    it "should not store more than 4 passwords" do
      User.destroy_all
      u = User.new(:email => "generic3@example.com")
      %w(Generic12 Generic13 Generic14 Generic15 Generic16 Generic17 Generic18).each do |pw|
        u.password = u.password_confirmation = pw
        u.save!
      end

      u.passwords.length.should == 4
    end
    
    it "should not be valid if password and confirmation are skipped" do
      u = User.new(:email => "generic@example.com")
      u.should_not be_valid
    end
    
    it "should create a user that can have a password validated against it" do
      email = "generic@example.com"
      password = "Ab12345"
      
      User.destroy_all
      returning(User.new(:email => email)) { |user|
        user.password = password
        user.password_confirmation = password
        user.save!
      }

      User.find_by_email(email).password_matches?(password).should == true
    end
    
    it "should not produce error messages that contain 'secret' or are duplicates" do
      u = User.new(:email => "generic@example.com")
      u.password = u.password_confirmation = nil
      u.valid?
      u.errors.to_a.should == u.errors.to_a.uniq
      u.errors.to_a.collect { |ar| ar.first }.should_not include('secret')
      u.errors.to_a.collect { |ar| ar.first }.should_not include('secret_confirmation')
    end
    
    it "should create #password" do
      u = User.new
      u.password.should be_blank
    end
    
    it "should create #password=" do
      u = User.new
      u.password = "hi there"
      u.password.should_not be_blank
    end
    
    it "should encrypt password assignments" do
      u = User.new
      u.password = "hi there"
      u.password.should_not == "hi there"
    end
    
    it "should create #password_confirmation" do
      u = User.new
      u.password_confirmation.should be_blank
    end
    
    it "should create #password_confirmation=" do
      u = User.new
      u.password_confirmation = "hi there"
      u.password_confirmation.should_not be_blank
    end
    
    it "should encrypt password confirmation assignments" do
      u = User.new
      u.password_confirmation = "hi there"
      u.password_confirmation.should_not == "hi there"
    end
    
    it "should delegate persistence token to password model" do
      u = User.new
      u.password = "hi there"
      u.persistence_token.should_not be_blank
    end
  end
  
  it "should reset the persistence token when password is assigned" do
    pw = Password.new
    pw.secret = "Hello12"
    pw.persistence_token.should_not be_blank
  end
  
  it "should encrypt the :secret and :secret_confirmation upon assignment in Password" do
    u = User.new
    pw = u.passwords.build
    pw.secret = "Hello12"
    pw.secret_confirmation = "Hello12"

    pw.secret.should_not == "Hello12" # ...but we don't know what it actually should equal, 'cause that's randomized.
    pw.secret_confirmation.should_not == "Hello12"
    pw.secret.should == pw.secret_confirmation
  end
  
  it "should force confirmation of the :secret on Password" do
    u = User.new
    pw = u.passwords.build
    pw.secret = "Hello12" 
    pw.valid?
    pw.errors.to_a.should_not be_empty
    
    pw.secret_confirmation = "Hello1"
    pw.valid?
    pw.errors.on(:secret).should == "doesn't match confirmation"
    
    pw.secret_confirmation = "Hello12"
    pw.should be_valid
  end
  
  it 'should validate presence of :secret on Password' do
    error_on(Password, :secret).should == "can't be blank"
  end
  
  it 'should validate password length >= 7' do    
    error_on(Password, :secret, "123456").should include("must be at least 7 characters")
  end

  it 'should validate password complexity' do
    error_on(Password, :secret, "Ab12345").should == nil
    error_on(Password, :secret, "1234567").should ==
             "must contain at least 1 uppercase, 1 lowercase and 1 number"
    error_on(Password, :secret, "abcdefg").should ==
             "must contain at least 1 uppercase, 1 lowercase and 1 number"
    error_on(Password, :secret, "ABCDEFG").should ==
             "must contain at least 1 uppercase, 1 lowercase and 1 number"
  end
  
  it 'should add has_many :passwords to User' do
    User.new.should respond_to(:passwords)
  end
  
  it "should expire passwords after 30 days or if no password is available" do
    (u = User.new).password_expired?.should be_true
    p = u.passwords.build(:created_at => 1.month.ago)
    p.authenticatable = u # need to build the reverse relationship cause it's not saved yet... i hate that.
    p.should be_expired
  end
  
  context "with password update frequency 90 days" do
    subject { Auth::Model.new(:user, :behaviors => [:core], :password_update_frequency => 90.days) }

    it "should expire passwords after 90 days or if no password is available" do
      (u = User.new).password_expired?.should be_true # because there're no passwords yet
      
      p = u.passwords.build(:created_at => 1.month.ago)
      p.authenticatable = u # need to build the reverse relationship cause it's not saved yet... i hate that.
      p.should_not be_expired
    end
  end
end

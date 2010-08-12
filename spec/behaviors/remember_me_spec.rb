require 'spec_helper'

if RSPEC_VERSION == 1
  require 'spec/rails'
end

describe 'Behavior: Remember Me', :type => :controller do
  if Rails::VERSION::MAJOR == 2
    controller_name 'sparkly_sessions' # just to shut rspec up about the missing ctrlr name
  elsif Rails::VERSION::MAJOR == 3
    include RSpec::Rails::ControllerExampleGroup
  end
  
  subject { controller }

  # How's this for ANNOYING: at least in its current (admittedly beta) form, RSpec 2 hard codes controller_class to
  # #describes -- which means the setter, self.controller_class=, is useless. Took me much longer than it should
  # have to figure that out.
  #
  # Also, RSpec 1 doesn't make it very easy (read: nigh unto impossible) to lazy load the controller class like we
  # need to do -- so it's been overridden here for all versions.
  def self.controller_class
    SparklySessionsController
  end
  
  def cookies
    subject.send(:cookies)
  end
  
  def reset_auth!
    # the lack of a current user will trigger authentication of various flavors, making these tests possible.
    subject.instance_variable_set("@current_user", nil)
  end
  
  configure_auth do |config|
    config.authenticate :user
    config.behaviors = :core, :remember_me
    config.remember_me.duration = 6.months
  end
  
  before(:each) do
#    User.destroy_all
#    Password.destroy_all
#    RemembranceToken.destroy_all
#    
    u = User.new(:email => "generic12@example.com")
    u.password = u.password_confirmation = "Generic12"
    u.save!
  end
  
  it "should log in successfully..." do
    post :create, { :model => "User", :user => { :email => "generic12@example.com", :password => "Generic12", :remember_me => true } }
    subject.current_user.should_not be_nil
  end
  
  it "should set an auth token cookie upon successful login" do
    post :create, { :model => "User", :user => { :email => "generic12@example.com", :password => "Generic12", :remember_me => true } }
    
    session[:session_token].should_not be_blank
    
    # There should be a token in the remebered_tokens table. We can use that data to decide
    # what should be in the cookie.
    RemembranceToken.count.should == 1
    
    # We're looking for a string containing password model ID, series token, and auth token.
    token = RemembranceToken.first
    
    cookies[:remembrance_token].should == token.value
  end
  
  context "a user with a remember token" do
    before(:each) do
      post :create, { :model => "User", :user => { :email => "generic12@example.com", :password => "Generic12", :remember_me => true } }
    end
    
    shared_examples_for "an expired or missing session" do
      it "should authenticate with the auth token cookie" do
        subject.current_user.should_not be_nil
      end
      
      it "should generate a new auth token cookie" do
        token = cookies[:remembrance_token]
        subject.current_user
        cookies[:remembrance_token].should_not == token
      end
      
      it "should not change the series identifier" do
        subject.current_user
        subject.current_user.remembrance_tokens.first.series_token == @series_identifier
      end
      
      context "and an invalid token id but valid series id" do
        before(:each) do
          cookies[:remembrance_token] = { :value => cookies[:remembrance_token]+"1", :expires => 6.months.from_now }
          reset_auth!
        end
        
        it "should be considered a theft" do
          # because the token is changed every time - if the wrong token is used it is due either to tampering or to
          # using an expired token, indicating that someone has stolen and used the one-use token.
          subject.current_user
          flash[:error].should == Auth.remember_me.token_theft_message
        end
        
        it "should delete all remembrance tokens" do
          subject.current_user.remembrance_tokens.count.should == 0
        end
      end
      
      context "and token data is not present" do
        before(:each) do
          cookies[:remembrance_token] = { :value => "", :expires => 6.months.from_now }
          reset_auth!
        end
        
        it "should not authenticate the user" do
          subject.current_user.should == false
        end
      end
      
      context "and token is missing" do
        before(:each) do
          cookies.delete(:remembrance_token)
          #cookies[:remembrance_token] = nil
          reset_auth!
        end
        
        it "should not authenticate the user" do
          subject.current_user.should == false
        end
      end
    end
    
    context "and an expired session" do
      before(:each) do
        @series_identifier = subject.current_user.remembrance_tokens.first.series_token
        session[:active_at] = 30.days.ago # i'm pretty sure this is past the session duration.
        reset_auth!
      end
      
      it_should_behave_like "an expired or missing session"
    end
    
    context "and a missing session" do
      before(:each) do
        @series_identifier = subject.current_user.remembrance_tokens.first.series_token
        session.clear
        reset_auth!
      end
      
      it_should_behave_like "an expired or missing session"
    end
  end
end

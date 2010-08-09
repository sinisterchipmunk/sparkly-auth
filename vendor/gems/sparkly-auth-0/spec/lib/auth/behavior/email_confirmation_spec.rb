require 'spec_helper'
require 'spec/rails'

describe "Behavior: Email Confirmation", :type => :controller do
#  controller_name :sparkly_sessions
#  
#  before(:each) do
#    Auth.configure do |c|
#      c.authenticate :user
#      c.behaviors = :core, :email_confirmation
#    end
#    
#    Auth.kick!
#  end
#  
#  context "when a user is created but not confirmed" do
#    before(:each) do
#      AuthenticatableMailer.should_receive(:deliver_signup)
#
#      u = User.new(:email => "generic13@example.com")
#      u.password = u.password_confirmation = "Generic13"
#      u.save!
#    end
#    
#    it "should not allow the user to log in" do
#      post :create, { :model => "User", :user => { :email => "generic13@example.com", :password => "Generic13" } }
#      session[:session_token].should be_blank
#    end
#
#    it "should flash a helpful error message" do
#      post :create, { :model => "User", :user => { :email => "generic13@example.com", :password => "Generic13" } }
#      flash[:error].should == Auth.email_confirmation.login_denied_message
#    end
#  end
end

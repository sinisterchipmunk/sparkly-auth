require 'spec_helper'

describe Auth::Behavior::Core::ControllerExtensions do
  #subject { ApplicationController.new }
  subject { ApplicationController.call(Rack::MockRequest.env_for("/").merge('REQUEST_URI' => '')).template.controller }
  
  before(:each) do
    Auth.configure do |config|
      config.session_duration = nil
      config.authenticate :user
    end
    
    Auth.kick!

    unless User.count == 1
      u = User.new(:email => "generic4@example.com")
      u.password = u.password_confirmation = "Generic12"
      u.save!
    end
  end
  
  it "should let users authenticate with single access token" do
    subject.params = { :single_access_token => User.first.single_access_token }
    subject.current_user.should be_kind_of(User)
  end
  
  it "should not raise nil errors when Auth.session_duration is nil" do
    subject.session = { :session_token => User.first.persistence_token }
    
    subject.current_user.should be_kind_of(User)
  end
end

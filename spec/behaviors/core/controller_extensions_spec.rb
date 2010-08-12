require 'spec_helper'

describe Auth::Behavior::Core::ControllerExtensions do
  if Rails::VERSION::MAJOR == 2
    subject { ApplicationController.call(Rack::MockRequest.env_for("/").merge('REQUEST_URI' => '')).template.controller }
  elsif Rails::VERSION::MAJOR == 3
    include RSpec::Rails::ControllerExampleGroup

    # How's this for ANNOYING: at least in its current (admittedly beta) form, RSpec 2 hard codes controller_class to
    # #describes -- which means the setter, self.controller_class=, is useless. Took me much longer than it should
    # have to figure that out.
    def self.controller_class
      ApplicationController
    end

    subject { controller }
    before(:each) do
      get :not_found
    end
  end
  
  configure_auth do |config|
    config.authenticate :user
    config.session_duration = nil
  end
  
  before(:each) do
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
    if subject.respond_to?(:session=) # Rails2
      subject.session = { :session_token => User.first.persistence_token }
    else                              # Rails3
      request.session = { :session_token => User.first.persistence_token }
    end
    
    subject.current_user.should be_kind_of(User)
  end
end

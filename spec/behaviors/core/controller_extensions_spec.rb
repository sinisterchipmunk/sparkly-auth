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

  it "should not reject mass assignments" do
    u = User.new(:email => "generic4@example.com", :password => "Admin01", :password_confirmation => "Admin01")
    u.should be_valid
  end

  context "with a default generic user" do
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

    it "should not regenerate the single access token on pw change" do
      token = User.find_by_email("generic4@example.com").single_access_token
      u = User.find_by_email("generic4@example.com")
      u.password = u.password_confirmation = "Password1"
      u.save!

      u.single_access_token.should == token
    end

    context "with expired password" do
      before(:each) do
        u = User.find_by_email("generic4@example.com")
        p = u.passwords.last
        p.created_at = 1.month.ago
        p.save!
      end

      it "should let users authenticate with single access token" do
        subject.params = { :single_access_token => User.first.single_access_token }
        subject.current_user.should be_kind_of(User)
        subject.current_user.password_expired?.should be_true
      end
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
end

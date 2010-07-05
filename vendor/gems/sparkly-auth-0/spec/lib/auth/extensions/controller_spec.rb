# OK - before anyone gives me "you're a hypocrite" flak, let me just explain something.
# I generally hate the idea of spec'ing controllers. I think that's a job best left
# to Cucumber. To be clear, I am not spec'ing a controller in this case - I'm spec'ing
# the extensions TO the controller. This makes perfect sense, because the extensions
# add internal code to the controller that should *not* always be accessible merely by
# changing the request, as an integration test would do.
#
# Eh, this should be a blog post, not a comment in a source file. But I had to get it
# out there. I'll clarify through the blog, and save the space here for Ruby code.

require 'spec_helper'

describe Auth::Behavior::Core::ControllerExtensions do
  subject { ApplicationController.new }
  
  before(:each) do
    Password.stub!(:columns).and_return([column("created_at"),
                                         column("secret"),
                                         column("salt"),
                                         column("persistence_token"),
                                         column("single_access_token"),
                                         column("perishable_token"),
                                         column("authenticatable_type"),
                                         column("authenticatable_id")])
    
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

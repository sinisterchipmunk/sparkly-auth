require 'spec_helper'

describe ApplicationController do
  # sanity check to make sure I haven't added methods and forgot to tell Rails they're not actions
  it "should have only 'not_found' action" do
    ApplicationController.action_methods.to_a.should == ["not_found"]
  end
end

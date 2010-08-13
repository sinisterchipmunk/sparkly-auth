
Given /^my session is expired$/ do
  Auth.configuration.session_duration = -1.second
end

Then /^I should not be logged in$/ do
  logged_in?.should == false
end

Then /^I should have a remembrance token$/ do
  response.template.controller.send(:cookies)[:remembrance_token].should_not be_blank
end

Then /^I should not have a remembrance token$/ do
  response.template.controller.send(:cookies)[:remembrance_token].should be_blank
end

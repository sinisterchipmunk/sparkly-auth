
Given /^I enter new user details$/ do
  fill_in 'email', :with => "generic@asdf.com"
  fill_in 'password', :with => 'Ad12345'
  fill_in 'password confirmation', :with => 'Ad12345'
  click_button "Sign up"
end

Given /^I delete my account$/ do
  delete user_path
end

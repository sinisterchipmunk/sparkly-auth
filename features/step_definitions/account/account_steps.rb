Given /^I enter new user details$/ do
  Given 'I enter new user details for "generic@example.com"'
end

Given /^I enter new user details for "([^"]*)"$/ do |email|
  fill_in 'email', :with => email
  fill_in 'password', :with => 'Generic12'
  fill_in 'password confirmation', :with => 'Generic12'
  click_button "Sign up"
  handle_redirect!
end

Given /^I delete my account$/ do
  delete user_path
  handle_redirect!
end

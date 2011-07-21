Given /^I enter new user details$/ do
  Given 'I enter new user details for "generic@example.com"'
end

Given /^I enter new user details for "([^"]*)"$/ do |email|
  fill_in 'Email', :with => email
  fill_in 'Password', :with => 'Generic12'
  fill_in 'Password confirmation', :with => 'Generic12'
  click_button "Sign up"
end

Given /^I delete my account$/ do
  visit user_path
  click_link "delete account"
end

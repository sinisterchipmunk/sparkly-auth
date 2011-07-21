Given /^I am logged in$/ do
  Given 'I am logged in as "generic@example.com"'
end

Given /^I am logged in as "([^"]*)"$/ do |email|
  if logged_in?
    When 'I log out'
  end
  
  if User.find_by_email(email).nil?
    Given "I create an account for \"#{email}\""
  end
  
  visit new_user_session_path
  fill_in 'Email', :with => email
  fill_in 'Password', :with => "Generic12"
  click_button "Sign in"

  page.should have_content("Signed in successfully.")
end

Given /^I am logged in and remembered$/ do
  Given 'I am logged in and remembered as "generic@example.com"'
end

Given /^I am logged in and remembered as "([^"]*)"$/ do |email|
  if User.find_by_email(email).nil?
    Given "I create an account for \"#{email}\""
  end
  
  visit new_user_session_path
  fill_in 'Email', :with => email
  fill_in 'Password', :with => "Generic12"
  check "Remember me"
  click_button "Sign in"

  page.should have_content("Signed in successfully.")
end

Then /^I should be logged in$/ do
  logged_in?.should == true
end

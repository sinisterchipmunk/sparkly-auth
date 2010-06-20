When /^I enter valid login credentials$/ do
  verify_user_exists!("generic@example.com", "Generic12")
  fill_in :email, :with => "generic@example.com"
  fill_in :password, :with => "Generic12"
  click_button "Sign in"
end

When /^I enter invalid login credentials$/ do
  verify_user_exists!("generic@example.com", "Generic12")
  fill_in :email, :with => "generic@example.com"
  fill_in :password, :with => "Generic1"
  click_button "Sign in"
end

When /^I enter invalid login credentials (\d+) times$/ do |count|
  count.to_i.times do
    fill_in :email, :with => "generic@example.com"
    fill_in :password, :with => "Generic1"
    click_button "Sign in"
  end
end

When /^I log out$/ do
  delete user_session_path
end

When /^I fail to log in (\d+) times$/ do |count|
  count.to_i.times do
    visit new_user_session_path
    fill_in :email, :with => "generic@example.com"
    fill_in :password, :with => "Generic1"
    click_button "Sign in"
  end
end

Given /^I am logged in$/ do
  verify_user_exists!("generic@example.com", "Generic12")
  User.first.password_matches?("Generic12").should == true
  
  visit new_user_session_path
  fill_in :email, :with => "generic@example.com"
  fill_in :password, :with => "Generic12"
  click_button "Sign in"
  response.should contain("Signed in successfully.")
end

Then /^I should be logged in$/ do
  logged_in?.should == true
end

Given /^my session is expired$/ do
  Auth.configuration.session_duration = -1.second
end

Then /^I should not be logged in$/ do
  logged_in?.should == false
end

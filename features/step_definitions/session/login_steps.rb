When /^I enter valid login credentials$/ do
  When 'I enter valid login credentials for "generic@example.com"'
end

When /^I enter valid login credentials for "([^"]*)"$/ do |email|
  fill_in 'Email', :with => email
  fill_in 'Password', :with => "Generic12"
  click_button "Sign in"
end

When /^I enter invalid login credentials$/ do
  fill_in 'Email', :with => "generic@example.com"
  fill_in 'Password', :with => "Generic1"
  click_button "Sign in"
end

When /^I enter invalid login credentials (\d+) times$/ do |count|
  count.to_i.times do
    fill_in 'Email', :with => "generic@example.com"
    fill_in 'Password', :with => "Generic1"
    click_button "Sign in"
  end
end

When /^I fail to log in (\d+) times$/ do |count|
  count.to_i.times do
    visit new_user_session_path
    fill_in 'Email', :with => "generic@example.com"
    fill_in 'Password', :with => "Generic1"
    click_button "Sign in"
  end
end


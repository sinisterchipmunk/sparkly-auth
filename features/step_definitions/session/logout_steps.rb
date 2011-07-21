When /^I log out$/ do
  visit logout_user_path
  page.should have_content("You have been signed out.")
end

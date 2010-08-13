When /^I log out$/ do
  delete user_session_path
  handle_redirect!
  response.should contain("You have been signed out.")
end

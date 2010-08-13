When /^I create an account for "([^"]*)"$/ do |email|
  Given "I am on the new user page"
  When "I enter new user details for \"#{email}\""
  Then 'I should see "account has been created"'
end

When /^I create an account$/ do
  Given 'I create an account for "generic@example.com"'
end

When /^I reload the application$/ do
  Dispatcher.cleanup_application
  Dispatcher.reload_application
end

Then /^show me the response$/ do
  puts response.body
end

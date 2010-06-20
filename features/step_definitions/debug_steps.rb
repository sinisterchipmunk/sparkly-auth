When /^I reload the application$/ do
  Dispatcher.cleanup_application
  Dispatcher.reload_application
end

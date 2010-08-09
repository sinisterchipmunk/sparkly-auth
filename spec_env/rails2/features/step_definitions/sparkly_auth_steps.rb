Given /^I am using the following behaviors: "([^"]*)"$/ do |behaviors|
  behaviors = behaviors.split(/,\s*/).collect { |beh| beh.to_sym }
  Auth.configuration.behaviors = behaviors
  Auth.kick!
end
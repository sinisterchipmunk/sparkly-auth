$VERBOSE = nil # this is to shut rack up about regexp, since I can't upgrade rack. rspec-rails relies on it.

if defined?(RSpec)
  require File.join(File.dirname(__FILE__), "../../spec_env/rails3/features/support/env")

  # REALLY not sure why this is necessary. Something keeps dirtying the test DB -- only in Rails 3.
  User.destroy_all
  Password.destroy_all
  RemembranceToken.destroy_all
else
  require File.join(File.dirname(__FILE__), "../../spec_env/rails2/features/support/env")
end

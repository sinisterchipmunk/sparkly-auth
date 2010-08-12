if defined?(RSpec)
  require File.join(File.dirname(__FILE__), "../../spec_env/rails3/features/support/env")
else
  require File.join(File.dirname(__FILE__), "../../spec_env/rails2/features/support/env")
end

if Rails::VERSION::STRING < "2.3.5" && Rails::VERSION::STRING.length <= 5
  raise "Sparkly auth requires Rails version 2.3.5 or higher"
elsif Rails::VERSION::MAJOR == 2
  require File.join(File.dirname(__FILE__), "init_rails2")
elsif Rails::VERSION::MAJOR >= 3
  require File.join(File.dirname(__FILE__), "init_rails3")
end

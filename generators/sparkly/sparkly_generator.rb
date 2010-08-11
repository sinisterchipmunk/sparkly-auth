if Rails::VERSION::MAJOR == 2
  require File.join(File.dirname(__FILE__), 'rails2')
else
  require File.join(File.dirname(__FILE__), 'rails3')
end

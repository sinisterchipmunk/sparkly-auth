for path in %w(app/models app/controllers app/helpers app/metal)
  path = File.expand_path File.join(File.dirname(__FILE__), '..', path)
  ActiveSupport::Dependencies.autoload_once_paths.delete path
end

require File.expand_path(File.join(File.dirname(__FILE__), "../../../../../../lib/sparkly-auth"))

# This file is what sets up Sparkly Auth to work properly with Rails. It was generated
# by "script/generate sparkly config" and can be regenerated with that command, though 
# you may not want to actually do that if you've made changes to this file.
#
# ***
# The ONLY thing you really need to look at is which models to authenticate; by default
# there's only one, and by default that one is User, so if you're happy with that then
# you're done.
# ***
#
# The rest of this file is littered with comments and settings. All of the settings
# mirror Sparkly Auth's own internal defaults; in other words, you can safely delete
# the remainder of this file without breaking anything. The options here are mostly
# shown as examples for you to override, if you need to do so.
#
# You are also encouraged to check out the Sparkly Auth RDoc documentation for more
# information regarding configuration options. The classes of interest in this case are
# Auth::Configuration and Auth::Model.

Auth.configure do |config|
  config.authenticate :user
  config.login_after_signup = true
  config.behaviors = [:core, :remember_me]
end

Before do
  puts User.count
  User.destroy_all
  Password.destroy_all
  RemembranceToken.destroy_all
  puts User.count
  
  # because some of the session tests modify this.
  Auth.configuration.session_duration = 30.minutes
end

After do
  puts User.count
  puts "::"
end

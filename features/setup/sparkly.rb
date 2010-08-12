Before do
  User.destroy_all
  Password.destroy_all
  RemembranceToken.destroy_all
  
  # because some of the session tests modify this.
  Auth.configuration.session_duration = 30.minutes
end

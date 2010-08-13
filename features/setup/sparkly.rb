Before do
  # because some of the session tests modify this.
  Auth.configuration.session_duration = 30.minutes
end

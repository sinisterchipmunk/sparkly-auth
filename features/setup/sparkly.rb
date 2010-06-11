Before do
  # because some of the session tests modify this.
  Auth.configuration.session_duration = 30.minutes

  # because somehow, I'm ending up with the odd user in the test DB after all features have run.
  User.destroy_all
end

After do
  # ditto, actually.
  User.destroy_all
end
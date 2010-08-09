class AuthenticatableMailer < ActionMailer::Base
  unloadable

  def signup(record)
    recipients record.email
    from       "system@example.com"
    subject    "New account information"
    body       :record => record
  end
end

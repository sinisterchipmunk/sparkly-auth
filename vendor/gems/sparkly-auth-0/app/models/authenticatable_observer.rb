class AuthenticatableObserver < Auth::Observer
  unloadable

  def after_create(model)
    AuthenticatableMailer.deliver_signup(model)
  end
end
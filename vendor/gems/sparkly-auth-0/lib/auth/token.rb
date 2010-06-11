class Auth::Token
  attr_reader :token
  alias_method :to_s, :token
  
  def initialize
    @hex = ActiveSupport::SecureRandom.hex(64)
    # base64 url, see RFC4648
    @token = SecureRandom.base64(15).tr('+/=', '-_ ').strip.delete("\n")
  end
end

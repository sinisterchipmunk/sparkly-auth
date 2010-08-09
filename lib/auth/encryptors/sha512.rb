class Auth::Encryptors::Sha512
  class << self
    attr_accessor :token_delimeter
    attr_writer :stretches
    
    def stretches
      @stretches ||= 20
    end
    
    def encrypt(*what)
      digest = what.flatten.join(token_delimeter)
      stretches.times { digest = Digest::SHA512.hexdigest(digest) }
      digest
    end
    
    def matches?(encrypted_copy, *what)
      encrypt(*what) == encrypted_copy
    end
  end
end

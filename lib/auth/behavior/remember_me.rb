module Auth
  module Behavior
    class RememberMe < Auth::Behavior::Base
      migration "create_sparkly_remembered_tokens"
      
      def apply_to_passwords(password)
        # no effect
      end
      
      def apply_to_accounts(model_config)
        model_config.target.instance_eval do
          has_many :remembrance_tokens, :dependent => :destroy, :as => :authenticatable
        end
      end
    end
  end
end

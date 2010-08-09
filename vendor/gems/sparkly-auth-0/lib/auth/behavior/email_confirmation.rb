module Auth
  module Behavior
    class EmailConfirmation < Auth::Behavior::Base
      migration "add_confirmed_to_sparkly_passwords"
      
      def apply_to_passwords(password)
        password.send(:define_method, :confirm!) do
          update_attribute(:confirmed, true)
        end
      end
      
      def apply_to_accounts(model_config)
        AuthenticatableObserver.instance.add_observer! model_config.target
      end
    end
  end
end

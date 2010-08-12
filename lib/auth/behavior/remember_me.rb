module Auth
  module Behavior
    class RememberMe < Auth::Behavior::Base
      migration "create_sparkly_remembered_tokens"
      
      def apply_to_controller(base_controller, user_model)
        ApplicationController.send(:include, Auth::Behavior::RememberMe::ControllerExtensions)
      end

      def apply_to_password(password_model, user_model)
        # no effect
      end
      
      def apply_to_user(user_model)
        user_model.auth_config.target.instance_eval do
          has_many :remembrance_tokens, :dependent => :destroy, :as => :authenticatable
        end
      end
    end
  end
end

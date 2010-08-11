module Auth
  module Behavior
    class RememberMe < Auth::Behavior::Base
      migration "create_sparkly_remembered_tokens"
      
      def apply_to_controllers(base_controller)
        require_dependency File.join(File.dirname(__FILE__), 'remember_me/controller_extensions')
        base_controller.send(:include, Auth::Behavior::RememberMe::ControllerExtensions)
        
        base_controller.class_eval do
          unless method_defined?(:login_without_remembrance!)
            alias_method_chain :login!, :remembrance
            alias_method_chain :logout!, :remembrance
            alias_method_chain :authenticate_current_user, :remembrance
          end
        end
      end

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

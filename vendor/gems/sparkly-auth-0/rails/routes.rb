if Auth.generate_routes?
  ActionController::Routing::Routes.draw do |map|
    Auth.configuration.authenticated_models.each do |model|
      catch :missing do
        begin
          model.name # if an error is going to occur due to missing model, it'll happen here.
        rescue NameError
          # we rescue silently because the user's already been warned.
          throw :missing
        end

        map.resource model.name.underscore, :controller => model.accounts_controller,
                                            :requirements => { :model => model.name } do |model_res|
          model_res.resource :session, :controller => model.sessions_controller, :requirements => { :model => model.name }
        end
      end
    end
  end
end

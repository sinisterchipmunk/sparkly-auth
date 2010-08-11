if Auth.generate_routes?
  Rails.application.routes.draw do
    Auth.configuration.authenticated_models.each do |model|
      catch :missing do
        begin
          model.name # if an error is going to occur due to missing model, it'll happen here.
        rescue NameError
          # we rescue silently because the user's already been warned (during startup).
          throw :missing
        end

        resource model.name.underscore, :model => model.name,
                 :controller => model.accounts_controller do
          resource :session, :controller => model.sessions_controller, :model => model.name
          match '/login', :to => "#{model.sessions_controller}#new", :as => "login"
          match '/logout', :to => "#{model.sessions_controller}#destroy", :as => "logout"
        end
#        map.resource model.name.underscore,
#                     :controller => model.accounts_controller,
#                     :requirements => { :model => model.name } do |model_res|
#          model_res.resource :session, :controller => model.sessions_controller, :requirements => { :model => model.name }
          
          # map some shorthand routes
#          model_res.login "login",
#                          :controller => model.sessions_controller,
#                          :action => 'new',
#                          :requirements => { :model => model.name }

#          model_res.logout "logout",
#                          :controller => model.sessions_controller,
#                          :action => 'destroy',
#                          :requirements => { :model => model.name }
#        end
      end
    end
  end
end

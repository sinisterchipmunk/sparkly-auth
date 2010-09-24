if Auth.generate_routes?
  Rails.application.routes.draw &Auth.routing_proc
end

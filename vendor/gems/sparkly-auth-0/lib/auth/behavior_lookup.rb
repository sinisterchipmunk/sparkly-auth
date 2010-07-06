module Auth::BehaviorLookup
  def lookup_behavior(behavior)
    name = behavior.to_s.underscore
    if name[/^auth\/behavior\//]
      behavior.to_s.camelize.constantize
    else
      "auth/behavior/#{name}".camelize.constantize
    end
  end
end

module Auth::BehaviorLookup
  def lookup_behavior(behavior)
    name = behavior.to_s.camelize
    if name[/^Auth::Behavior::/]
      name.constantize
    else
      "Auth::Behavior::#{name}".constantize
    end
  end
end

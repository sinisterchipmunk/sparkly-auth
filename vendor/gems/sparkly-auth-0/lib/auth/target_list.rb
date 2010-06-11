class Auth::TargetList < Array
  def find(which)
    select { |o| o.matches?(which) }.shift
  end
end

require 'spec_helper'

describe Auth::Behavior::RememberMe::Configuration do
  configure_auth do |config|
    config.authenticate :user
    config.behaviors = :core, :remember_me
  end
  
  it "should be accessible from a model" do
    User.sparkly_config.remember_me.should be_kind_of(Auth::Behavior::RememberMe::Configuration)
  end
  
  it "should be enabled" do
    Auth.remember_me.should be_enabled
  end
end

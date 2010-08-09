require 'spec_helper'

describe SparklySessionsController do
  it "should work after app reload" do
    get :new, :model => "User"
    Dispatcher.cleanup_application
    Dispatcher.reload_application
    get :new, :model => "User"
  end
end

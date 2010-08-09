describe 'routes' do
  include ActionController::UrlWriter
  
  before(:each) do
    Auth.configure do |config|
      config.authenticate :user
    end
    
    Auth.kick!
    ActionController::Routing::Routes.install_helpers([self.class])
  end
  
  it "should map new_user_path to /user/new" do
    new_user_path.should == '/user/new'
  end
  
  it "should map edit_user_path to /user/edit" do
    edit_user_path.should == '/user/edit'
  end
  
  it "should map user_path to /user" do
    user_path.should == '/user'
  end
end

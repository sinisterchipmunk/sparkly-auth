require 'spec_helper'

describe :sparkly do
  before(:each) do
    Auth.configure do |config|
      config.authenticate :user
    end
  end

  context "with :remember_me behavior" do
    before(:each) { Auth.configure { |c| c.behaviors << :remember_me } }
    
    with_args :migrations do
      it "should generate a remembered_tokens migration" do
        subject.should generate("db/migrate/002_create_sparkly_remembered_tokens.rb")
      end
    end
  end
  
  context "with :reset_password behavior" do
    before(:each) { Auth.configure { |c| c.behaviors << :reset_password } }
    
    with_args :migrations do
      it "should generate a reset_password migration" do
        subject.should generate("db/migrate/00#{Auth.behaviors.length}_add_sparkly_lockout_to_passwords.rb")
      end
    end
  end
  
  with_args :migrations do
    it "should generate db/migrate" do
      subject.should generate("db/migrate")
      subject.should generate("db/migrate/001_create_sparkly_passwords.rb")
    end
  end

  with_args :config do
    it "should generate the sparkly initializers" do
      subject.should generate('lib/tasks/sparkly_migration.rb')
      subject.should generate('config/initializers/sparkly_authentication.rb')
    end
  end
  
  with_args :controllers do
    it "should generate the sparkly controllers" do
      Auth.configuration.authenticate(:user, :accounts_controller => 'users', :sessions_controller => 'user_sessions')
      Auth.kick!
      
      subject.should generate("app/controllers/users_controller.rb")
      subject.should generate("app/controllers/user_sessions_controller.rb")
      subject.should generate("app/helpers/users_helper.rb")
      subject.should generate("app/helpers/user_sessions_helper.rb")
    end
  end
  
  with_args :views do
    it "should generate the sparkly views with /users if given the users controller" do
      Auth.configuration.authenticate(:user, :accounts_controller => 'users', :sessions_controller => 'user_sessions')
      Auth.kick!
      
      subject.should generate("app/views/users/_form.html.erb")
      subject.should generate("app/views/users/edit.html.erb")
      subject.should generate("app/views/users/new.html.erb")
      subject.should generate("app/views/users/show.html.erb")
      subject.should generate("app/views/user_sessions/new.html.erb")
    end
  end
  
  with_args :help do
    it "should generate the sparkly help" do
      subject.should generate('doc/sparkly_authentication.txt')
    end
  end
end

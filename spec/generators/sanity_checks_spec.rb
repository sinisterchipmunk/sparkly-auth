require 'spec_helper'

# Sanity checks that remind me to change a template when I change the corresponding code, or
# to add a file that I might otherwise forget.

describe :sparkly do
  def self.it_should_generate_and_match(to_gen, existing = to_gen)
    it "should generate #{to_gen} which matches #{existing}" do
      existing = File.join(File.dirname(__FILE__), '../../', existing)
      subject.should generate(to_gen) { |content| content.strip.should == File.read(existing).strip }
    end
  end
  
  before(:each) do
    Auth.configuration.authenticate(:user,
                                    :accounts_controller => 'sparkly_accounts',
                                    :sessions_controller => 'sparkly_sessions')
    Auth.kick!
  end
  
  it "should verify that no files are generated that are missing from code base, or vice versa." # tbi
  
  context "sanity checks" do
    with_args "configs", '-q' do
      # configs can vary widely but the test here is to verify that the default generated config matches
      # the one we're currently using. That way we can verify that it'll at least work out of the box.
      it_should_generate_and_match("config/initializers/sparkly_authentication.rb", "spec_env/rails3/config/initializers/sparkly_authentication.rb")
    end
    
    context "migrations", '-q' do
      # migrations take care of themselves because I simply add them in place and then regenerate them
      # in the test projects directly.
    end
    
    with_args 'views', '-q' do
      it_should_generate_and_match('app/views/sparkly_accounts/edit.html.erb')
      it_should_generate_and_match('app/views/sparkly_accounts/new.html.erb')
      it_should_generate_and_match('app/views/sparkly_accounts/show.html.erb')
      
      it_should_generate_and_match('app/views/sparkly_sessions/new.html.erb')
    end

    with_args 'controllers', '-q' do
      it_should_generate_and_match('app/controllers/sparkly_accounts_controller.rb')
      it_should_generate_and_match('app/controllers/sparkly_sessions_controller.rb')
      it_should_generate_and_match('app/helpers/sparkly_accounts_helper.rb')
      it_should_generate_and_match('app/helpers/sparkly_sessions_helper.rb')
    end
  end
end

ENV['RAILS_ENV'] = 'test'
ENV['DEFER_SPARKLY'] = 'true'  # Sparkly will infer Auth.defer_kickstart from env
ENV['AUTH_BACKTRACE'] = 'true' # Sparkly will dump backtrace if NameError encountered during init

if defined?(RSpec)
  RSPEC_VERSION = 2
  require File.expand_path(File.join(File.dirname(__FILE__), "../spec_env/rails3/config/boot"))
  require File.expand_path(File.join(File.dirname(__FILE__), "../spec_env/rails3/config/environment"))
else
  RSPEC_VERSION = 1
  #require File.expand_path(File.join(File.dirname(__FILE__), "../spec_env/rails2/config/boot"))
  require File.expand_path(File.join(File.dirname(__FILE__), "../spec_env/rails2/config/environment"))
end

['email_spec', 'genspec'].each do |gem_name|
  begin
    require gem_name
  rescue LoadError
    puts " >> Missing gem: 'genspec' <<"
    puts 
    puts "These specs rely on genspec, which tests the project's generators."
    puts
    raise
  end
end

module InstanceHelpers
  def reload!
    if Rails.configuration.cache_classes
      raise "Cannot reload: set Rails.configuration.cache_classes to false first"
    end
    if Rails::VERSION::MAJOR == 2
      Dispatcher.cleanup_application
      #Dispatcher.reload_application
    else
      ActiveSupport::Dependencies.clear
      #ActionDispatch::Callbacks.new(Proc.new {}, false).call({})
    end
  end
  
  def _sparkly_configurations
    self.class.all_sparkly_configurations
  end
  
  def apply_sparkly_configuration!
    reload!
    Auth.reset_configuration!
    if !_sparkly_configurations.empty?
      _sparkly_configurations.each do |config|
        Auth.configure &config
      end
      Auth.kick! # because we deferred kicking during preparation
    end
  end
end

module ClassHelpers
  def configure_auth(&block)
    if block_given?
      # we have to defer configuration until runtime otherwise all specs will end up
      # using the last configuration defined, which is an error.
      self.sparkly_configurations ||= [] # why ?
      sparkly_configurations << block
    end
    sparkly_configurations
  end
  
  def all_sparkly_configurations
    ret = []
    ret.concat sparkly_configurations if sparkly_configurations
    if RSPEC_VERSION == 2 && superclass.respond_to?(:sparkly_configurations)
      ret = superclass.all_sparkly_configurations + ret # parents should run first.
    end
    ret
  end
  
  def self.extended(base)
    base.instance_eval do
      class_inheritable_array :sparkly_configurations
      read_inheritable_attribute(:sparkly_configurations) || write_inheritable_attribute(:sparkly_configurations, [])
    end
  end
end

# a safeguard against the 'old way'
Auth.class_eval do
  class << self
    def reset_double_prevention!
      @reset_configuration_with_double_prevention = nil
      @kick_with_double_prevention = nil
    end
      
    def reset_configuration_with_double_prevention!
      if @reset_configuration_with_double_prevention
        raise "Auth#reset_configuration! was already called"
      end
      @reset_configuration_with_double_prevention = 1
      reset_configuration_without_double_prevention!
    end

    def kick_with_double_prevention!
      if @kick_with_double_prevention
        raise "Auth#kick! was already called"
      end
      @kicm_with_double_prevention = 1
      kick_without_double_prevention!
    end

    alias_method_chain :reset_configuration!, :double_prevention
    alias_method_chain :kick!, :double_prevention
  end
end

if RSPEC_VERSION == 1
  require 'spec/rails'
  require File.join(File.dirname(__FILE__), 'spec2_helper')
else
  require 'rspec/rails'
  require File.join(File.dirname(__FILE__), 'spec3_helper')
end

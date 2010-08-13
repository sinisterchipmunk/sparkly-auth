class Auth::Behavior::Base::Configuration
  # Provides a handle back to the root configuration object.
  attr_reader :configuration

  include Auth::Configuration::Keys
  
  class << self
    def configuration_name(new_name = nil)
      if new_name
        @configuration_name = new_name.to_sym
      else
        # the sub removes Configuration, ie Auth::Behavior::Core::Configuration becomes Auth::Behavior::Core
        @configuration_name = name.sub(/\:\:[^\:]*$/, '').demodulize.underscore.to_sym
      end
    end
  end
  
  # Returns true if the root configuration object's behaviors include :remember_me.
  def enabled?
    configuration.behaviors.include? configuration_name
  end
  
  def configuration_name
    self.class.configuration_name
  end
  
  def initialize(configuration)
    @configuration = configuration
    defaults!
  end
  
  def defaults!
    raise "Don't forget to override #{self.class.name}#defaults!"
  end
  
  alias reset! defaults!
end
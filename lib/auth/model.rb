class Auth::Model
  module Authenticated
    def self.included(base)
      base.send(:cattr_accessor, :sparkly_config)
    end
  end
  
  
  def self.option(name, default = name)
    define_method(name) do
      self.options[name] ||= Auth.configuration.send(default)
    end
  end
  
  include Auth::BehaviorLookup
  attr_reader :options
  option :behaviors
  option :password_update_frequency
  option :accounts_controller, :default_accounts_controller_name
  option :sessions_controller, :default_sessions_controller_name
  delegate :name, :table_name, :to => :target
  
  # Options include:
  #   :behaviors                 => an array of behaviors to override Auth.configuration.behaviors
  #   :password_update_frequency => a time (ie 30.days) to override Auth.configuration.password_update_frequency
  #   :skip_routes               => true if you do not want to generate routes (useful if you need to map them yourself).
  #   :key                       => the key upon which to authenticate (the username, basically)
  #   :with                      => a regular expression used to validate the password
  #   :accounts_controller       => the name of the controller to route to for creating accounts, deleting them, etc.
  #   :sessions_controller       => the name of the controller to route to for logging in, logging out, etc.
  #
  def initialize(name_or_constant, options = {})
    begin
      @target = resolve(name_or_constant).name
    rescue NameError
      # we fail silently because the user might not have generated the model yet. That would mean they're trying
      # to do it now.
      @target = name_or_constant.to_s.camelize
    end
    
    @options = options.reverse_merge(default_options)
  end
  
  def target
    klass = @target.constantize
    unless klass.include?(Auth::Model::Authenticated)
      klass.send(:include, Auth::Model::Authenticated)
      klass.sparkly_config = self
    end
    klass
  end
  
  # Returns true if the specified String, Symbol or constant resolves to the same constant affected by this Model.
  def matches?(name_or_constant)
    target == resolve(name_or_constant)
  end
  
  # The key upon which this model is to be authenticated. (The username.) Defaults to :email
  def key
    options[:key]
  end
  
  # Merges the specified hash of options with this Model's hash of options. Same as model.options.merge!(options)
  def merge_options!(options)
    self.options.merge! options
  end
  
  def apply_options!
    apply_behaviors!
  end
  
  private
  def apply_behaviors!
    behaviors.each do |behavior|
      behavior = lookup_behavior(behavior)
      behavior.new.apply_to(self)
    end
  end
  
  def resolve(name_or_constant)
    case name_or_constant
      when Symbol then name_or_constant.to_s.camelize.constantize
      when String then name_or_constant.camelize.constantize
      else name_or_constant
    end
  end
  
  def default_options
  {
    :key => :email,
    :with => :password
  }
  end
end

require 'fileutils'

module GenerationMatchers
  class GenerationMatcher
    delegate :generation_methods, :to => 'self.class'
    
    def initialize(kind = nil, *args)
      raise ArgumentError, "Call with kind" unless kind
      @kind = kind.to_s
      @args = args
      @but_found = nil
    end
        
    def self.generation_methods
      @generation_methods ||= %w(dependency class_collisions file template complex_template directory readme
                                 migration_template route_resources)
    end
    
    def matches?(target)
      temporary_root(target) do
        replay(target)
      end
      matched?
    end
    
    def failure_message
      "Expected to generate #{@kind}#{with_file}#{but_found}"
    end
    
    def negative_failure_message
      "Expected not to generate #{@kind}#{with_file}"
    end
    
    protected
    
    def replay(target)
      @create = Rails::Generator::Commands::Create.new(target)
      target.manifest.replay(self)
      after_replay(target)
    end
    
    # hook
    def after_replay(target)
    end
    
    def matched!
      @matched = true
    end
    
    def matched?
      !!@matched
    end

    private
    def temporary_root(target)
      # We could bear to split this into two methods, one called #suspend_logging or some such.
      original_root = target.instance_variable_get("@destination_root")
      original_logger = Rails::Generator::Base.logger
      original_quiet = target.logger.quiet
      log = ""

      ### WHY does this not work? Instead we are forced to reroute the log output rather than just silence it.
      target.logger.quiet = true
      Rails::Generator::Base.logger = Rails::Generator::SimpleLogger.new(StringIO.new(log))

      Dir.mktmpdir do |dir|
        # need to copy a few files for some methods, ie route_resources
        Dir.mkdir(File.join(dir, "config"))
        FileUtils.cp File.join(RAILS_ROOT, "config/routes.rb"), File.join(dir, "config/routes.rb")
        target.instance_variable_set("@destination_root", dir)
        yield
      end
    rescue
      if original_logger != Rails::Generator::Base.logger
        Kernel::raise $!.class, "#{$!.message}\n#{log}", $!.backtrace
      else
        Kernel::raise $!
      end
    ensure
      Rails::Generator::Base.logger = original_logger
      target.logger.quiet = original_quiet
      target.instance_variable_set("@destination_root", original_root)
    end

    def but_found
      if @but_found.nil?
        ""
      else
        ",\n    but found #{@but_found.inspect}"
      end
    end
    
    def with_file
      !@args.empty? ? "\n    with #{@args.inspect}" : ""
    end

    def method_missing(name, *args, &block)
      if generation_methods.include? name.to_s
        @create.send(name, *args, &block)
        if name.to_s == @kind && (@args.empty? || args == @args)
          matched!
        elsif name.to_s == @kind
          @but_found = args
        else
          nil
        end
      else super
      end
    #rescue
    #  Kernel::raise $!.class, $!.message, caller
    end
  end
  
  class ResultMatcher < GenerationMatcher
    attr_reader :filename
    
    def initialize(filename, &block)
      @filename = filename
      @block = block
      super(:does_not_matter)
    end
    
    def after_replay(target)
      path = File.join(target.destination_root, filename)
      if File.exist?(path)
        matched!
        validate_block(target, path)
      end
    end
    
    def failure_message
      "Expected to generate file #{filename}"
    end
    
    def negative_failure_message
      "Expected to not generate file #{filename}"
    end
    
    private
    def validate_block(target, path)
      if @block
        if @block.arity == 2
          @block.call(File.read(path), target)
        else
          @block.call(File.read(path))
        end
      else
        true
      end
    end
  end
  
  # Valid types: :dependency, :class_collisions, :file, :template, :complex_template, :directory, :readme,
  # :migration_template, :route_resources
  def generate(kind, *args, &block)
    case kind.to_s
      when *GenerationMatcher.generation_methods
        GenerationMatcher.new(kind, *args, &block)
      else
        if kind.kind_of?(String)
          ResultMatcher.new(kind, &block)
        else
          raise ArgumentError, "No generator matcher for #{kind.inspect}"
        end
    end
  end
end

class GeneratorExampleGroup
  extend Spec::Example::ExampleGroupMethods
  include Spec::Example::ExampleMethods
  include GenerationMatchers
  delegate :generator_arguments, :generator_options, :generator_args, :to => "self.class"
  
  class << self
    def generator_arguments
      @generator_args.dup || []
    end
    
    def generator_options
      @generator_options.dup.reverse_merge(:quiet => true) || { :quiet => true }
    end
    
    def with_arguments(*args, &block)
      if block_given?
        context "with arguments #{args.inspect}" do
          with_arguments(*args)
          instance_eval(&block)
        end
      else
        @generator_args = args.flatten.collect { |c| c.to_s }
      end
    end
    
    def with_options(hash, &block)
      if block_given?
        context "with options #{hash.inspect}" do
          with_options(hash)
          instance_eval(&block)
        end
      else
        @generator_options = hash
      end
    end
    
    alias_method :generator_args, :generator_arguments
    alias_method :with_args, :with_arguments
  end
  
  def subject(&block)
    block.nil? ?
      explicit_subject || implicit_subject : @explicit_subject_block = block
  end

  private
  def explicit_subject
    group = self
    while group.respond_to?(:explicit_subject_block)
      return group.explicit_subject_block if group.explicit_subject_block
      group = group.superclass
    end
  end

  def implicit_subject
    target = example_group_hierarchy[1].described_class || example_group_hierarchy[1].description_args.first
    
    if target.kind_of?(Symbol) || target.kind_of?(String)
      target = self.class.lookup_missing_generator("#{target.to_s.underscore}_generator".camelize)
    end
    target.new(generator_args)
  end
end

if defined?(RAILS_ROOT)
  require 'rails_generator'
  require 'rails_generator/scripts/generate'
end

Spec::Example::ExampleGroupFactory.register(:generator, GeneratorExampleGroup)


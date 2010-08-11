class SparklyGenerator < Rails::Generator::NamedBase
  # I'm still treating this as NamedBase because I'm not sure whether I'll need that in the future.
  def initialize(args, options = {}) #:nodoc:
    @options = options
    unless args.empty?
      which = args.first
      @type = which.downcase
      args << "generic" if nameless_type?
    end
    super(args, options)
  end
  
  def manifest
    record do |m|
      case @type
        when *nameless_types then send(@type, m)
        else raise ArgumentError, "Expected type to be one of #{nameless_types.to_sentence(:connector => 'or ')}"
      end
    end
  end
  
  private
  def help(m)
    m.directory 'doc'
    m.file 'help_file.txt', 'doc/sparkly_authentication.txt'
    logger.log '', File.read(File.join(File.dirname(__FILE__), 'templates/help_file.txt'))
    logger.quiet = true # we plan to tell the user the file has been saved, so why tell them twice?
  end
  
  def controllers(m)
    spawn_model_generator(m, Auth::Generators::ControllersGenerator)
  end
  
  def routes(m)
    spawn_model_generator(m, Auth::Generators::RouteGenerator)
  end
  
  def views(m)
    spawn_model_generator(m, Auth::Generators::ViewsGenerator)
  end
  
  def migrations(m)
    spawn_model_generator(m, Auth::Generators::MigrationGenerator)
  end
  
  def config(m)
    spawn_generator(m, Auth::Generators::ConfigurationGenerator, [])
  end
  
  def spawn_model_generator(manifest, type)
    each_model do |model|
      spawn_generator(manifest, type, model)
    end
  end
  
  def spawn_generator(manifest, type, args)
    generator = type.new(args, spawned_generator_options)
    generator.manifest.replay(manifest)
  end
  
  def each_model(&block)
    Auth.configuration.authenticated_models.each &block
  end
  
  def nameless_type?
    nameless_types.include? @type
  end
  
  def nameless_types
    %w(migrations config help views controllers)
  end
  
  def spawned_generator_options
    options.merge(:source => File.join(source_root), :destination => destination_root)
  end
end

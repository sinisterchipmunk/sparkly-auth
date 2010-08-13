module Auth
  class Configuration
    # When included by a configuration object, the Keys module will override #attr_reader, #attr_writer and
    # #attr_accessor to add configuration keys for each. A #to_hash instance method is generated which will
    # this object into a Hash containing only the registered keys.
    #
    module Keys
      # Returns this configuration as a Hash
      def to_hash
        configuration_keys.inject({}) do |hash, key|
          hash[key] = send(key)
          hash
        end
      end
      
      def configuration_keys
        self.class.configuration_keys
      end

      def self.included(base)
        base.class_eval do
          class << self
            def configuration_keys
              @configuration_keys ||= []
            end
      
            def add_configuration_key(*keys)
              configuration_keys.concat keys.flatten
            end
      
            def attr_reader(*args) #:nodoc:
              add_configuration_key(*args)
              super
            end
      
            def attr_writer(*args) #:nodoc:
              add_configuration_key(*args)
              super
            end
      
            def attr_accessor(*args) #:nodoc:
              add_configuration_key(*args)
              super
            end
          end
        end
      end
    end
  end
end

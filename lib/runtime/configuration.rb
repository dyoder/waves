module Waves

  # Waves configurations are Ruby code.  This means you can use a Ruby expression as
  # the value of a configuration attribute, extend and inherit your configurations, and
  # add your own attributes. You can even use it as a repository
  # for your application configuration.
  #
  # You can access configuration attributes using the attribute name as a method, with the value as the argument.
  #
  # == Example
  #
  #    module Blog
  #      module Configurations
  #        class Development < Default
  #          host '127.0.0.1'
  #          port 2000
  #          reloadable [ Blog ]
  #          log :level => :debug
  #          application do
  #            use Rack::ShowExceptions
  #            run Waves::Dispatchers::Default.new
  #          end
  #        end
  #      end
  #    end
  #
  # There are three forms for accessing attributes:
  #
  #   Waves.config.port                        # generic form - gets the value for current config
  #   Blog.configurations[:development].port   # gets the value for a specified config
  #   Blog::Configurations::Development.port   # Access a specific config constant directly
  #
  # Configuration data is inheritable, as shown in the example above. Typically, you
  # would set data common to all configurations in the Default class, from which
  # your variations inherit.
  #
  # You may define your own heritable attributes using the +attribute+ class method:
  #
  #   class Default < Waves::Configurations::Default
  #     attribute 'theme' # define an attribute named "theme"
  #     theme 'ultra'     # set an inheritable default
  #   end
  #
  # Certain attributes are reserved for internal use by Waves:
  #
  # - application: configure the application for use with Rack
  # - database: initialization parameters needed by the ORM layer
  # - reloadable: an array of module names to reload; see below for more
  # - log: takes a hash of parameters; see below for more
  # - host: the host to bind the server to (string)
  # - port: the port for the server to listen on (number)
  # - ports: used by the cluster:start task for clustering servers (array of numbers)
  # - debug: true if running in "debug" mode, which automatically reloads code
  #
  # == Configuring The Rack Application
  #
  # One of the really nice features of Rack is the ability to install "middleware"
  # components to optimize the way you handle requests. Waves exposes this ability
  # directly to the application developer via the +application+ configuration method.
  #
  # *Example*
  #
  #   # Typical debugging configuration
  #   application do
  #     use Rack::ShowExceptions
  #     run Waves::Dispatchers::Default.new
  #   end
  #
  # == Configuring Database Access
  #
  # The ORM layers provided with Waves use the +database+ attribute for connection initialization.
  # Most ORMs take a hash for this purpose, with keys that may vary depending on the ORM and backend.
  #
  #   # Sequel with a MySQL db
  #   database :host => 'localhost', :adapter => 'mysql', :database => 'blog',
  #     :user => 'root', :password => 'guess'
  #
  #   # Sequel with an SQLite db
  #   database :adapter => 'sqlite', :database => 'blog'
  #
  # See the documentation for each ORM layer for details.
  #
  # == Configuring Code Reloading
  #
  # The +reloadable+ attribute takes an array of modules. Before every request, the default Waves 
  # dispatcher calls +reload+ on each listed module.  The module should remove any reloadable constants
  # currently defined in its namespace.  
  #
  # In a Waves application built on the Default foundation, +reload+ functionality is provided
  # by AutoCode for the Configurations, Controllers, Helpers, Models, and Views modules.
  # 
  # Listing only your application module will work in most cases:  
  #
  #   reloadable [ Blog ]
  #
  # As an alternative, you could reload only some of the modules within your application:
  #
  #   reloadable [ Blog::Models, Blog::Controllers ]
  #
  # == Configuring Logging
  #
  # The +log+ configuration attribute takes hash with these keys:
  # - :level - The log filter level. Uses Ruby's built in Logger class.
  # - :output - A filename or IO object. Should be a filename if running as a daemon.
  #
  # *Examples*
  #
  #  log :level => :info, :output => $stderr
  #  log :level => :error, :output => 'log/blog.log'
  #

  module Configurations

    class Base
      # Set the given attribute with the given value. Typically, you wouldn't
      # use this directly.
      def self.[]=( name, val )
        meta_def("_#{name}") { val }
      end

      # Get the value of the given attribute. Typically, you wouldn't
      # use this directly.
      def self.[]( name ) ; send "_#{name}" ; end

      # Define a new attribute. After calling this, you can get and set the value
      # using the attribute name as the method
      def self.attribute( name )
        meta_def(name) do |*args|
          raise ArgumentError.new('Too many arguments.') if args.length > 1
          args.length == 1 ? self[ name ] = args.first : self[ name ]
        end
        self[ name ] = nil
      end

    end

    # The Default configuration defines sensible defaults for attributes required by Waves.
    #   debug true
    #   synchronize? true
    #   session :duration => 30.minutes, :path => '/tmp/sessions'
    #   log :level => :info, :output => $stderr
    #   reloadable []
    class Default < Base

      %w( host port ports log reloadable resource database session pid
        debug root dependencies cache console ).each { |name| attribute(name) }

      # Set the Rack handler, along with any specific options
      # that need to be passed to the handler's #run method. 
      #
      # When accessing the value
      # (calling with no arguments), returns an array of the handler and options.
      def self.server( server = nil )
        if server
          self['server'] = server
        else
          self['server']
        end
      end

      # Provides access to the Waves::MimeTypes class via the configuration. You
      # can override #mime_types to return your own MIME types repository class.
      def self.mime_types
        Waves::MimeTypes
      end

      # Defines the application for use with Rack.  Treat this method like an
      # instance of Rack::Builder
      def self.application( &block )
        if block_given?
          self['application'] = Rack::Builder.new( &block )
        else
          self['application']
        end
      end
      
      debug true
      session :duration => 30.minutes, :path => '/tmp/sessions'
      log :level => :info, :output => $stderr
      reloadable []
      dependencies []
      cache :dir => 'cache'
      pid "#{$$}.pid"
      server Waves::Servers::WEBrick
      application {
        use ::Rack::ShowExceptions
        run ::Waves::Dispatchers::Default.new
      }
      console 3333
      
    end
  end
end



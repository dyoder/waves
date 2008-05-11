module Waves

  # Waves configurations are simply Ruby code, meaning you can use an Ruby expression as
  # a value for a configuration parameter, extend and inherit your configurations, and
  # add your own configuration attributes. You can even use it as a configuration repository
  # for your applications.
  #
  # The form for configuration parameters to use the parameter name as a method name. Passing
  # in a parameter sets the value.
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
  # There are three forms for accessing parameters:
  #
  #   Waves.config.port                        # generic form - gets current config
  #   Blog.configurations[:development]        # gets a value for a specific config
  #   Blog::Configurations::Development.port   # Access config constant directly
  #
  # You can inherit configurations, as is shown in the example above. Typically, you
  # can use the application's "default" configuration to set shared configurations,
  # and then inherit from it for specific variations.
  #
  # To define your own attributes, and still make them inheritable, you should use
  # the +attribute+ class method, like this:
  #
  #   class Default < Waves::Configurations::Default
  #     attribute 'theme' # define a theme attribute
  #     theme 'ultra'     # give it a default
  #   end
  #
  # There are a number of reserved or built-in attributes. These are:
  #
  # - application: configure the application for use with Rack
  # - database: takes a hash of parameters used to initalize the database; see below
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
  # directly to the application developer via the +application+ configuration parameter.
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
  # The database parameter takes a hash with the following elements:
  #
  # - host: which host the database is running on
  # - adapter: which adapter is being used to access the database (mysql, postgres, etc.)
  # - database: the name of the database the application is connecting to
  # - user: the user for authentication
  # - password: password for authentication
  #
  # *Example*
  #
  #   database :host => 'localhost', :adapter => 'mysql', :database => 'blog',
  #     :user => 'root', :password => 'guess'
  #
  #
  # == Configuring Code Reloading
  #
  # You can specify a list of modules to reload on each request using the +reloadable+
  # configuration parameter. The Waves server will call +reload+ on each module to trigger
  # the reloading. Typically, your modules will use the Autocode gem to set parameters for
  # reloading. This is done for you when you generate an application using the +waves+
  # command, but you can change the default settings. See the documentation for Autocode
  # for more information. Typically, you will set this parameter to just include your
  # main application:
  #
  #   reloadable [ Blog ]
  #
  # although you could do this with several modules just as easily (say, your primary
  # application and several helper applications).
  #
  # == Configuring Logging
  #
  # The +log+ configuration parameter takes the following options (as a hash):
  # - level: The level to filter logging at. Uses Ruby's built in Logger class.
  # - output: A filename or IO object. Should be a filename if running as a daemon.
  #
  # *Examples*
  #
  # log :level => :info, :output => $stderr
  # log :level => :error, :output => 'log/blog.log'
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

      # Define a new attribute. After calling this, you can get and set the value.
      def self.attribute( name )
        meta_def(name) do |*args|
          raise ArgumentError.new('Too many arguments.') if args.length > 1
          args.length == 1 ? self[ name ] = args.first : self[ name ]
        end
        self[ name ] = nil
      end

    end

    # The Default configuration provides a good starting point for your applications,
    # defining a number of attributes that are required by Waves.
    class Default < Base

      %w( host port ports log reloadable database session debug root ).
      each { |name| attribute(name) }

      # Set the handler for use with Rack, along with any handler-specific options
      # that will be passed to the handler's #run method. When accessing the value
      # (calling with no arguments) returns an array of the handler and options.
      def self.handler(*args)
        if args.length > 0
          @rack_handler, @rack_handler_options = args
        else
          [ @rack_handler, @rack_handler_options ]
        end
      end

      # Provide access to the Waves::MimeTypes class via the configuration. You
      # could potentially point this to your own MIME types repository class.
      def self.mime_types
        Waves::MimeTypes
      end

      # Defines the application for use with Rack.
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
    end
  end
end



module Waves

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
        debug root dependencies cache console monitor ).each { |name| attribute(name) }

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
      pid "#{$$}.pid"
      server Waves::Servers::WEBrick
      application {
        use ::Rack::ShowExceptions
        run ::Waves::Dispatchers::Default.new
      }      
    end
  end
end



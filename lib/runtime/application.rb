# See the README for an overview.
module Waves

  class << self

    # Access the principal Waves application.
    attr_reader :application

    # Register a module as a Waves application.
    # Also, initialize the database connection if necessary.
    def << ( app ) 
      @application = app if Module === app
      # app.database if app.respond_to? 'database'
    end

    def instance ; Waves::Application.instance ; end

    def method_missing(name,*args,&block)
      instance.send(name,*args,&block)
    end

  end

  # An application in Waves is anything that provides access to the Waves
  # runtime and the registered Waves applications. This includes both
  # Waves::Server and Waves::Console. Waves::Application is *not* the actual
  # application module(s) registered as Waves applications. To access the
  # main Waves application, you can use +Waves+.+application+.
  class Application

    class << self; attr_accessor :instance; end

    # Accessor for options passed to the application.
    attr_reader :options

    # Create a new Waves application instance.
    def initialize( options={} )
      @options = options
      Dir.chdir options[:directory] if options[:directory]
      Application.instance = self
      Kernel.load( :lib / 'application.rb' ) if Waves.application.nil?
    end

    def synchronize( &block )
      ( @mutex ||= Mutex.new ).synchronize( &block )
    end

    # The 'mode' of the application determines which configuration it will run under.
    def mode
      @mode ||= @options[:mode]||:development
    end
    
    # Debug is true if debug is set to true in the current configuration.
    def debug? ; config.debug ; end

    # Access the current configuration. *Example:* +Waves::Server.config+
    def config
      Waves.application.configurations[ mode ]
    end

    # Access the mappings for the application.
    def mapping ; Waves.application.configurations[ :mapping ] ; end

    # Reload the modules specified in the current configuration.
    def reload ; config.reloadable.each { |mod| mod.reload } ; end

    # Returns the cache set for the current configuration
    def cache ; config.cache ; end
  end

end

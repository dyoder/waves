# See the README for an overview.
module Waves
  
  # A temporary measure until the applications "array" becomes a hash.
  # Currently used to keep track of all loaded Waves applications.
  class Applications < Array
    def []( name ) ; self.find { |app| app.name == name.to_s.camel_case } ; end
  end

  # The list of all loaded applications
  def self.applications ; @applications ||= Applications.new ; end

  # Deprecated. Do not write new code against this.
  def self.application ; warn "Waves.application is deprecated"; applications.last ; end
  
  # Access the principal Waves application.
  def self.main ; applications.first ; end
  
  # Register a module as a Waves application.
  def self.<< ( app )
    applications << app if Module === app
  end

  # Returns the most recently created instance of Waves::Runtime.
  def self.instance ; Waves::Runtime.instance ; end
  
  def self.version ; File.read( File.expand_path( "#{File.dirname(__FILE__)}/../../doc/VERSION" ) ) ; end

  def self.method_missing(name,*args,&block) ; instance.send(name,*args,&block) ; end

  # A Waves::Runtime takes an inert application module and gives it concrete, pokeable form.
  # Waves::Server and Waves::Console are types of runtime.  
  class Runtime

    class << self; attr_accessor :instance; end

    # Accessor for options passed to the application.
    attr_reader :options

    # Create a new Waves application instance.
    def initialize( options={} )
      @options = options
      Dir.chdir options[:directory] if options[:directory]
      Runtime.instance = self
      Kernel.load( :lib / 'application.rb' ) if Waves.main.nil?
    end

    def synchronize( &block )
      ( @mutex ||= Mutex.new ).synchronize( &block )
    end

    # The 'mode' of the application determines which configuration it will run under.
    def mode
      @mode ||= @options[:mode]||:development
    end
    
    # Returns true if debug was set to true in the current configuration.
    def debug? ; config.debug ; end

    # Returns the current configuration.
    def config
      Waves.main::Configurations[ mode ]
    end

    # Returns the mappings for the application.
    def mapping ; Waves.main::Configurations[ :mapping ] ; end

    # Reload the modules specified in the current configuration.
    def reload ; config.reloadable.each { |mod| mod.reload } ; end

    # Returns the cache set for the current configuration
    def cache ; config.cache ; end
  end

end

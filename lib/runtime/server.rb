module Waves
  # You can run the Waves::Server via the +waves-server+ command or via <tt>rake cluster:start</tt>. Run <tt>waves-server --help</tt> for options on the <tt>waves-server</tt> command. The <tt>cluster:start</tt> task uses the +mode+ environment variable to determine the active configuration. You can define +port+ to run on a single port, or +ports+ (taking an array) to run on multiple ports.
  #
  # *Example*
  #
  # Assume that +ports+ is set in the development configuration like this:
  #
  #   ports [ 2020, 2021, 2022 ]
  #
  # Then you could start up instances on all three ports using:
  #
  #   rake cluster:start mode=development
  #
  # This is the equivalent of running:
  #
  #   waves-server -c development -p 2020 -d
  #   waves-server -c development -p 2021 -d
  #   waves-server -c development -p 2022 -d
  #
  # The +cluster:stop+ task stops all of the instances.
  #
  class Server < Runtime

    # Access the server thread.
    attr_reader :thread

    # Access the host we're binding to (set via the configuration).
    def host ; options[:host] || config.host ; end

    # Access the port we're listening on (set via the configuration).
    def port ; options[:port] || config.port ; end

    # Run the server as a daemon. Corresponds to the -d switch on +waves-server+.
    def daemonize
      pwd = Dir.pwd
      Daemonize.daemonize( Waves::Logger.output )
      Dir.chdir(pwd)
      File.write( :log / "#{port}.pid", $$ )
    end

    def trap(signal)
      Kernel::trap(signal) { yield }
      Thread.new { loop {sleep 1} } if RUBY_PLATFORM =~ /mswin32/
    end

    # Start and / or access the Waves::Logger instance.
    def log
      @log ||= Waves::Logger.start
    end

    # Start the server.
    def start
      daemonize if options[:daemon]
      start_debugger if options[:debugger]
      log.info "** Waves Server #{Waves.version} starting  on #{host}:#{port}"
      handler, options = config.handler
      handler.run( config.application.to_app, options ) do |server|
        @server = server
        self.trap('INT') { puts; stop } if @server.respond_to? :stop
      end
    end

    # Stop the server.
    def stop
      log.info "** Waves Server Stopping ..."
      if options[:daemon]
        pid_file = :log / $$ + '.pid'; FileUtils.rm( pid_file ) if File.exist?( pid_file )
      end
      @server.stop
      log.info "** Waves Server Stopped"
    end

    # Provides access to the server mutex for thread-safe operation.
    def synchronize( &block ) ; ( @mutex ||= Mutex.new ).synchronize( &block ) ; end

    class << self
      private :new, :dup, :clone
      # Start or restart the server.
      def run( options={} )
        @server.stop if @server; @server = new( options ); @server.start
      end
      
      # Allows us to access the Waves::Server instance.
      def method_missing(*args)
        @server.send(*args)
      end
      
      #-- Probably wouldn't need this if I added a block parameter to method_missing.
      def synchronize(&block) ; @server.synchronize(&block) ; end
    end

    private

    def start_debugger
      begin
        require 'ruby-debug'
        Debugger.start
        Debugger.settings[:autoeval] = true if Debugger.respond_to?(:settings)
        log.info "Debugger enabled"
      rescue Exception
        log.info "You need to install ruby-debug to run the server in debugging mode. With gems, use 'gem install ruby-debug'"
        exit
      end
    end
  end

end

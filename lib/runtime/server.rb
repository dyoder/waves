module Waves
	# You can run the Waves::Server via the +waves-server+ command or via <tt>rake cluster:start</tt>. Run <tt>waves-server --help</tt> for options on the <tt>waves-server</tt> command. The <tt>cluster.start</tt> task use the +mode+ environment parameter to determine which configuration to use. You can define +port+ to run on a single port, or +ports+ (taking an array) to run on multiple ports.
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
	class Server < Application
		
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
		  File.write( :log / $$+'.pid', '' )
		end
		# Start and / or access the Waves::Logger instance.
		def log ; @log ||= Waves::Logger.start ; end
		# Start the server.
		def start
		  start_debugger # if options[:debugger]
			load( :lib / 'startup.rb' )
		  daemonize if options[:daemon]
			log.info "** Waves Server Starting ..."
			t = real_start
			log.info "** Waves Server Running on #{host}:#{port}"
			log.info "Server started in #{(t*1000).round} ms."
			@thread.join
		end
		# Stop the server.
		def stop
			log.info "** Waves Server Stopping ..."
			pid_file = :log / $$ + '.pid'
			FileUtils.rm( pid_file ) if options[:daemon] and File.exist?( pid_file )
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
			def method_missing(*args); @server.send(*args); end
			# Probably wouldn't need this if I added a block parameter to method_missing.
			def synchronize(&block) ; @server.synchronize(&block) ; end
		end
		
		private
		
		def real_start
		  Benchmark.realtime do
				@server = ::Mongrel::HttpServer.new( host, port )
				@server.register('/', Rack::Handler::Mongrel.new( config.application.to_app	 ) )
				trap('INT') { puts; stop }; @thread = @server.run
			end
		end

    def start_debugger
      begin
        require 'ruby-debug'
        Debugger.start
        Debugger.settings[:autoeval] = true if Debugger.respond_to?(:settings)
        # log.info "Debugger enabled"
      rescue Exception
        log.info "You need to install ruby-debug to run the server in debugging mode. With gems, use 'gem install ruby-debug'"
        exit
      end
    end
	end
	
end
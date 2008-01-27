module Waves
	
	class Server < Application
				
		attr_reader :thread
		
		def start
			load( :lib / 'startup.rb' )
			Waves::Logger.start
			log.info "** Waves Server Starting ..."
			
			t = Benchmark.realtime do
				app = config.application.to_app				
				@server = ::Mongrel::HttpServer.new( config.host, config.port )
				@server.register('/', Rack::Handler::Mongrel.new( app ) )
				trap('INT') { puts; stop }
				@thread = @server.run
			end
			log.info "** Waves Server Running on #{config.host}:#{config.port}"
			log.info "Server started in #{(t*1000).round} milliseconds."
			@thread.join
		end
		
		def stop
			log.info "** Waves Server Stopping ..."
			@server.stop 
			log.info "** Waves Server Stopped"
		end
		
		def synchronize( &block )
			( @mutex ||= Mutex.new ).synchronize( &block )
		end
		
		def cache
			#@cache ||= MemCache::new '127.0.0.1'
		end
		
		# make this a singleton ... we don't use Ruby's std lib
		# singleton module because it doesn't do quite what we
		# want - need a run method and implicit instance method
		class << self
			
			private :new, :dup, :clone
			
			def run( mode = :development )
				@server.stop if @server; @server = new( mode ); @server.start
			end
			
			# allow Waves::Server to act as The Server Instance
			def method_missing(*args); @server.send(*args); end
			
			def synchronize(&block) ; @server.synchronize(&block) ; end
			
		end

	end
	
end

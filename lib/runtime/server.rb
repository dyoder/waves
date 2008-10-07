module Waves
  
  class Server < Runtime
    
    def host ; options[:host] || config.host ; end
    def port ; options[:port] || config.port ; end
    def ports ; config.ports || [ port ] ; end
    def application ; config.application.to_app ; end
    
    def Server.run( options )
      @manager = new( options )
      Server.trap( 'INT' ) { } 
      Server.trap( 'HUP' ) { @manager.restart }
      @manager.start
    end
    
    def Server.trap(signal)
      Kernel::trap(signal) { yield }
      Thread.new { loop { sleep 1 } } if RUBY_PLATFORM =~ /mswin32/
    end
        
    def start
      daemonize if options[ :daemon ]
      Waves::Logger.start
      Waves::Logger.info "Waves version #{Waves.version} starting"
      start_debugger if options[ :debugger ]
      unless RUBY_PLATFORM =~ /mswin32/
        start_servers
      else
        config.servers.call( application, host, port )
      end
      Process.waitall
    end
    
    def daemonize
      pwd = Dir.pwd
      Daemonize.daemonize( Waves::Logger.output )
      Dir.chdir(pwd)
    end
    
    def start_debugger
      require 'ruby-debug'
      Debugger.start
      Debugger.settings[:autoeval] = true if Debugger.respond_to?(:settings)
      Waves::Logger.info "ruby-debug enabled"
    end
    
    def start_servers
      @pids = [] ; ports.each do | port |
        @pids << fork do
          Server.trap( 'INT' ) { exit }
          connect = false
          until connect do
            begin
              config.server.call( application, host, port ) do | server |
                Waves::Logger.info "Waves server started on #{host}:#{port}."
                Server.trap('INT') do
                  server.stop if server.respond_to? :stop
                  Waves::Logger.info "Waves server on #{host}:#{port} stopped."
                end
                connect = true
              end
            rescue Exception => e
              Waves::Logger.info e
            end
          end
        end
      end
    end
        
    def stop
      @pids.each { | pid | Process.kill( 'INT', pid ) }
    end
    
    def restart
      stop ; start_servers
    end
    
    # unless RUBY_PLATFORM =~ /mswin32/
    #   def reload ; Process.kill('HUP', Process.ppid ) ; end
    # end
    
    
  end
  
end
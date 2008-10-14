require 'live_console'
module Waves
  
  class Manager < Runtime
    
    def self.run( options )
      @manager ||= new( options )
      @manager.start ; self
    end
    
    def self.instance ; @manager ; end
    class << self ; private :new, :allocate ; end
    private :dup, :clone
    
    def start
      daemonize if options[ :daemon ]
      start_logger ; set_traps
      start_debugger if options[ :debugger ]
      start_servers ; start_console
      sleep 60 while true
    end
    
    def stop
      Waves::Logger.info "Manager shutting down ..."
      @console.stop ; stop_servers ; Process.waitall
      exit
    end
    
    def restart
      stop_servers; start_servers
    end
    
    private
    
    def daemonize
      pwd = Dir.pwd ; exit if fork ; Dir.chdir( pwd )
      File.umask 0000 ; STDIN.reopen( '/dev/null') ; 
      STDOUT.reopen( '/dev/null', 'a' ) ; STDERR.reopen( STDOUT )
    end
    
    def set_traps
      safe_trap( 'HUP' ) { restart }
      safe_trap( 'TERM','INT' ) { stop }
    end
    
    def start_logger
      Waves::Logger.start
      Waves::Logger.info "Manager starting up ..."
    end
    
    def start_console
      @console = LiveConsole.new( config.console )
      @console.run
      Waves::Logger.info "Console started on port #{config.console}"
    end
    
    def start_debugger
      require 'ruby-debug' ; Debugger.start
      Debugger.settings[:autoeval] = true if Debugger.respond_to?(:settings)
      Waves::Logger.info "ruby-debug enabled"
    end
    
    def start_servers
      @pids = ( config.ports or [ config.port ] ).map do | port | 
        config.server.run( config.application, config.host, port )
      end
    end

    def stop_servers
      @pids.each { | pid | Process.kill( 'INT', pid ) }
    end
    
  end
  
end
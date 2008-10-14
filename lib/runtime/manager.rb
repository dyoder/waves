require 'live_console'
module Waves
  
  class Manager < Runtime
    
    def self.run( options )
      @manager ||= new( options )
      @manager.start ; self
    end
    
    class << self ; private :new, :dup, :clone ; end
    def self.instance ; @manager ; end
    
    def start
      daemonize if options[ :daemon ]
      set_traps ; start_logger ; start_console
      start_debugger if options[ :debugger ]
      start_servers ; Process.waitall
    end
    
    def stop
      Waves::Logger.info "Manager shutting down ..."
      @console.stop ; stop_servers ; exit
    end
    
    def restart
      stop_servers ; start_servers
    end
    
    def daemonize
      pwd = Dir.pwd ; exit if fork ; Dir.chdir( pwd )
      File.umask 0000 ; STDIN.reopen( '/dev/null') ; 
      STDOUT.reopen( '/dev/null', 'a' ) ; STDERR.reopen( STDOUT )
    end
    
    def set_traps
      safe_trap( 'HUP' ) { restart }
      safe_trap( 'INT' ) { stop }
    end
    
    def start_logger
      Waves::Logger.start
      Waves::Logger.info "Waves #{Waves.version} starting up ..."
    end
    
    def start_console
      @console = LiveConsole.new( config.console )
      @console.run
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
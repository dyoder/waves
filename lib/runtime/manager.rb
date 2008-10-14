require 'live_console'
module Waves
  
  class Manager < Runtime
    
    def self.run( options )
      @manager ||= new( options )
      @manager.start
    end
    
    def self.instance ; @manager ; end
    class << self ; private :new, :allocate ; end
    private :dup, :clone
    
    def start
      pid = daemonize if options[ :daemon ]
      return pid if pid
      start_logger ; set_traps
      start_debugger if options[ :debugger ]
      start_servers ; start_monitor ; start_console
      sleep 60 while true
    end
    
    def stop
      Waves::Logger.info "Manager shutting down ..."
      @console.stop if @console ; @monitor.stop if @monitor
      stop_servers ; Process.waitall ; exit
    end
    
    def restart
      stop_servers; start_servers
    end
    
    private
    
    def daemonize
      pwd = Dir.pwd ; pid = fork ; return pid if pid ; Dir.chdir( pwd )
      File.umask 0000 ; STDIN.reopen( '/dev/null') ; 
      STDOUT.reopen( '/dev/null', 'a' ) ; STDERR.reopen( STDOUT )
      nil # return nil for child process, just like fork does
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
      if config.console
        @console = config.console ; @console.run
        Waves::Logger.info "Console started on port #{config.console}"
      end
    end
    
    def start_monitor
      unless config.debug
        @monitor = Waves.config.monitor
        pid = @monitor.start( self )
        Waves::Logger.info "Monitor started with PID #{pid}"
      end
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
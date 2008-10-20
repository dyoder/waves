require 'drb'
module Waves
  
  # "Workers" are just dedicated processes. Managers, Servers, and Monitors are all
  # examples of Workers. This class just encapsulates the common features across all
  # Workers: daemonization, signal traps, console support, logging, only-ness, etc.
  
  class Worker < Runtime
    
    def self.run( options )
      @instance ||= new( options )
      @instance.start
    end
    
    # make this the one-and-only
    def self.instance ; @instance ; end
    class << self ; private :new, :allocate ; end
    private :dup, :clone
    
    # returns the PID of the new process
    def start
      pid = daemonize if options[ :daemon ]
      return pid if pid
      # from here on in, we're in the daemon
      start_logger
      Waves::Logger.info "#{self.class} starting ..."
      set_traps
      start_debugger if options[ :debugger ]
      start_console
      start_interface
      start_tasks.join
    end
    
    def stop
      Waves::Logger.info "#{self.class} shutting down ..."
      @console.stop if @console
      stop_tasks
    end
    
    def restart ; stop ; start ; end
        
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
      Waves::Logger.info "Logger started."
    end
    
    def start_console
      if config.console
        @console = config.console ; @console.start
        Waves::Logger.info "Console started on port #{config.console.port}"
      end
    end
    
    def start_debugger
      require 'ruby-debug' ; Debugger.start
      Debugger.settings[:autoeval] = true if Debugger.respond_to?(:settings)
      Waves::Logger.info "ruby-debug enabled"
    end
    
    protected 
    
    # workers should override these methods
    def start_tasks
    end

    def stop_tasks
    end
    
    # for management, monitoring
    def start_interface
    end
    
  end
  
end
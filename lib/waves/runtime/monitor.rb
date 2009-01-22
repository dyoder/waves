module Waves
  
  class Monitor
    
    def initialize( options ) ; @options = options ; end
    
    def start( manager )
      @manager = manager
      @pid = fork do
        safe_trap('INT','TERM') do
          Waves::Logger.info "Monitor stopped ..."
          exit
        end
        loop { fix unless check ; sleep interval }
      end
    end
    
    def fix
      @manager.restart
    end
    
    # you need to implement this
    def check ; true ; end
    
    # defaults to every 60 seconds
    def interval ; @options[ :interval ] ; end
    
    def stop ; Process.kill( 'INT', @pid ) ; end
    
  end
  
end
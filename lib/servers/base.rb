module Waves
  
  module Servers
    
    class Base
      
      attr_accessor :application, :host, :port, :server
      
      # returns the PID of the server process
      def self.run( application, host, port ) 
        fork { new( application, host, port ).run }
      end
      
      def initialize( application, host, port ) 
        @application = application; @host = host ; @port = port
      end
      
      # starts server, retrying every few seconds until it succeeds
      def run
        connect = false
        until connect do
          begin
            call { |server| @server = server ; start }
          rescue
            Waves::Logger.error e.to_s
            sleep 4
          end
          connect = true
        end
      end
      
      def start
        Waves::Logger.info "Waves server started on #{host}:#{port}."
        safe_trap('INT') { stop }
      end
      
      def stop
        server.stop if server.respond_to? :stop
        Waves::Logger.info "Waves server on #{host}:#{port} stopped."
      end
      
    end
  end
end
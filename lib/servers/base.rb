module Waves
  
  module Servers
    
    # Inherit from this class and define the #call method to create Servers.
    # Like Rack Handlers, except with an attempt at a more generic interface.
    # The #call method should yield with the actual server object.
    
    class Base
      
      attr_reader :application, :host, :port
      def initialize( application, host, port )
        @application = application
        @host = host ;@port = port
      end
      
      # starts server, retrying every second until it succeeds
      def start
        Thread.new do
          connect = false
          until connect do
            begin
              call do |server| 
                @server = server
                Waves::Logger.info "#{self.class.basename} started on #{host}:#{port}."
              end
            rescue
              Waves::Logger.error e.to_s
              sleep 1
            end
            connect = true
          end
        end
      end
      
      def stop
        Waves::Logger.info "#{self.class.basename} on #{host}:#{port} stopped."
      end
      
    end
  end
end
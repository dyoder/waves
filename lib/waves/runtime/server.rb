module Waves
  
  class Server < Worker
    
    def start_tasks
      @server = config.server.new( application, host, port )
      @server.start
    end
    
    def stop_tasks ; @server.stop ; end
    
    private

    def application ; @app ||= config.application.to_app ; end
    def port ; @port ||= options[:port] or config.port ; end
    def host ; @host ||= options[:host] or config.host ; end

  end

end
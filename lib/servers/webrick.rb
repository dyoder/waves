module Waves
  module Servers
    class WEBrick < Base
      
      def call
        Rack::Handler::WEBrick.run( application, :Host => host, :Port => port ) { | server | yield server if block_given? }
      end
      
      def stop ; @server.stop ; super ; end
      
    end
  end
end
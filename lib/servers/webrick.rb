module Waves
  module Servers
    class WEBrick
      def call( app, host, port )
        Rack::Handler::WEBrick.run( app, :Host => host, :Port => port ) { yield self if block_given? }
      end
    end
  end
end
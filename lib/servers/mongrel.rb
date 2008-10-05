module Waves
  module Servers
    class Mongrel
      def call( app, host, port )
        Rack::Handler::Mongrel.run( app, :Host => host, :Port => port ) { |server| yield server if block_given? }
      end
    end
  end
end
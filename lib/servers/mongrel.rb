module Waves
  module Servers
    class Mongrel < Base
      def call
        Rack::Handler::Mongrel.run( application, :Host => host, :Port => port ) { |server| yield server if block_given? }
      end
    end
  end
end
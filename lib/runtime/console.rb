require 'runtime/mocks'
module Waves

  class Console < Runtime

    class << self

      attr_reader :console

      def load( options={} )
        @console ||= Waves::Console.new( options )
        Kernel.load( options[:startup] || 'startup.rb' )
        Object.instance_eval { include Waves::Mocks }
      end

      # allow Waves::Console to act as The Console Instance
      def method_missing(*args); @console.send(*args); end

    end

  end

end

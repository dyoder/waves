module Waves

  class Console < Runtime

    class << self

      attr_reader :console

      def load( options={} )
        @console ||= Waves::Console.new( options )
        require 'runtime/mock_mixin'
      end

      # allow Waves::Console to act as The Console Instance
      def method_missing(*args); @console.send(*args); end

    end

  end

end

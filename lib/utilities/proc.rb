module Waves
  module Utilities
    module Proc
      # calls the given lambda with the receiver as its argument
      def |(lambda)
        lambda do
          lambda.call( self.call )
        end
      end
    end
  end
end

class Proc # :nodoc:
  include Waves::Utilities::Proc
end
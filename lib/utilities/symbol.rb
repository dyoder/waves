module Waves
  module Utilities
    module Symbol
      # Does File.join on self and string, converting self to string before invocation.
      # See String#/ for more.
      def / ( string )
        self.to_s / string
      end
    end
  end
end

class Symbol # :nodoc:
  include Waves::Utilities::Symbol
end
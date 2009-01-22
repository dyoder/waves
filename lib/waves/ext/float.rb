module Waves
  module Ext
    module Float
      def to_delimited(delim=',')
        self.to_s.gsub(/(\d)(?=(\d\d\d)+\.)/, "\\1#{delim}")
      end
    end
  end
end

class Float # :nodoc:
  include Waves::Ext::Float
end
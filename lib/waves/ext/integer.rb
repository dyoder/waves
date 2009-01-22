module Waves
  module Ext
    module Integer
      def seconds ; self ; end
      def minutes ; self * 60 ; end
      def hours ; self * 60.minutes ; end
      def days ; self * 24.hours ; end
      def weeks ; self * 7.days ; end
      def bytes ; self ; end
      def kilobytes ; self * 1024 ; end
      def megabytes ; self * 1024.kilobytes ; end
      def gigabytes ; self * 1024.megabytes ; end
      def terabytes ; self * 1024.gigabytes ; end
      def petabytes ; self * 1024.terabytes ; end
      def exabytes ; self * 1024.petabytes ; end
      def zettabytes ; self * 1024.exabytes ; end
      def yottabytes ; self * 1024.zettabytes ; end
      def to_delimited(delim=',')
        self.to_s.gsub(/(\d)(?=(\d\d\d)+$)/, "\\1#{delim}")
      end
    end
  end
end

class Integer # :nodoc:
  include Waves::Ext::Integer
end
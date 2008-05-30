module Waves
  module Helpers
    module NumberHelper

      # Formats a +number+ with grouped thousands using +delimiter+. You
      # can customize the format in the +options+ hash.
      # * <tt>:delimiter</tt>  - Sets the thousands delimiter, defaults to ","
      # * <tt>:separator</tt>  - Sets the separator between the units, defaults to "."
      #
      #  number_with_delimiter(12345678)      => 12,345,678
      #  number_with_delimiter(12345678.05)   => 12,345,678.05
      #  number_with_delimiter(12345678, :delimiter => ".")   => 12.345.678
      def number_with_delimiter(number, delimiter=",", separator=".")
        begin
          parts = number.to_s.split(separator)
          parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{delimiter}")
          parts.join separator
        rescue
          number
        end
      end

    end
  end
end

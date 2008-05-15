module DefaultApplication
  module Helpers
    module Testing
      include Waves::Helpers::Default
      def self.foundation_testing
        true
      end
    end
  end
end

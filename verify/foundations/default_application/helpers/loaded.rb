module DefaultApplication
  module Helpers
    module Loaded
      include Waves::Helpers::Default
      def self.foundation_testing
        true
      end
    end
  end
end

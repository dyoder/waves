module Waves
  module Helpers
    module Basic
      attr_reader :request
      include Waves::ResponseMixin
      
      def app ; Waves.main ; end
      
    end
  end
end
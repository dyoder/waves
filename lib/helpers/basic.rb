module Waves
  module Helpers
    module Basic
      attr_reader :request
      include Waves::ResponseMixin
    end
  end
end
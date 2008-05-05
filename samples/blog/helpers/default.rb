module Blog
  module Helpers
    module Defaul
      attr_reader :request, :conten
      include Waves::ResponseMixin
      include Waves::Helpers::Common
      include Waves::Helpers::Formatting
      include Waves::Helpers::Model
      include Waves::Helpers::View
      include Waves::Helpers::Form
    end
  end
end

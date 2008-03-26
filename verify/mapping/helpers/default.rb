module Test
	module Helpers
		module Default
			attr_reader :request, :content
			include Waves::ResponseMixin
			include Waves::Helpers::Common
			include Waves::Helpers::Formatting
			include Waves::Helpers::Model
			include Waves::Helpers::View
			include Waves::Helpers::Form
		end
	end
end
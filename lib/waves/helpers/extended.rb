require 'waves/helpers/basic'
require 'waves/helpers/doc_type'
require 'waves/helpers/layouts'
require 'waves/helpers/formatting'
require 'waves/helpers/model'
require 'waves/helpers/view'
require 'waves/helpers/form'

module Waves
  module Helpers
    module Extended
      include Waves::Helpers::Basic
      include Waves::Helpers::DocType
      include Waves::Helpers::Layouts
      include Waves::Helpers::Formatting
      include Waves::Helpers::Model
      include Waves::Helpers::View
      include Waves::Helpers::Form
    end
  end
end

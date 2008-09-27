require 'helpers/basic'
require 'helpers/doc_type'
require 'helpers/layouts'
require 'helpers/formatting'
require 'helpers/model'
require 'helpers/view'
require 'helpers/form'

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
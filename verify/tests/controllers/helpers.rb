require "#{File.dirname(__FILE__)}/../../helpers"
require 'controllers/mixin'

module VerifyControllers
  module Models
    class Default
    end
  end
  module Controllers
    class Default < Waves::Controllers::Base; end
  end
end

VerifyControllers::Models.stub!(:[]).with(:default).and_return(VerifyControllers::Models::Default)

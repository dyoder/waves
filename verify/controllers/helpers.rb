require File.join(File.dirname(__FILE__) , "..", "helpers")

module TestApp
  module Models
    class Default
    end
  end
  module Controllers
    class Default < Waves::Controllers::Base; end
  end
end

TestApp::Models.stub!(:[]).with(:default).and_return(TestApp::Models::Default)
Waves.application.stub!(:models).and_return(TestApp::Models)
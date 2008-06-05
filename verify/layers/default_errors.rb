# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

module DefaultErrorsApp
  include Waves::Foundations::Simple
  include Waves::Layers::DefaultErrors
  module Views
    class Errors
      include Waves::Views::Mixin
      def not_found_404(arg)
        "View-based 404"
      end
    end
  end
  stub!(:views).and_return(Views)
end

# Waves << DefaultErrorsApp
Waves::Console.load( :mode => :development )


describe "An application which includes the DefaultErrors layer" do
  
  it "registers a view-based handler for NotFound errors" do    
    r = get('/bogus')
    r.body.should == "View-based 404"
  end
  
end
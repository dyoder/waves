# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__), "..", "helpers")

module Test 
  module Controllers
    class Animal
      include Waves::Controllers::Mixin
      def cow() 'Moo!' end
    end
  end
  module Views
    class Animal
      include Waves::Views::Mixin
      def say( says ) "This animal says: '#{says}'" end
    end
  end
end

specification "A developer may succintly define a resource-based controller-view chain." do
      
  before do
    mapping.clear
    path('/cow' ) do 
      resource( :animal ) { controller { cow } | view { | says | say( says ) } }
    end
  end

  specify 'Pipe output of controller to view within a resource context.' do
    get('/cow').body.should == "This animal says: 'Moo!'"
  end
  

end


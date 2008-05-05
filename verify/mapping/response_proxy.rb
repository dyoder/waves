# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__), "..", "helpers")

# Note: you have to define the resource classes using module_eval here, because otherwise
# the autocreate code never gets triggered in the application.

module Tes
  include Waves::Layers::MVC
end

Test::Controllers.module_eval do
  class Animal
    include Waves::Controllers::Mixin
    def cow() 'Moo!' end
  end
end

Test::Views.module_eval do
  class Animal
    include Waves::Views::Mixin
    def say( says ) "This animal says: '#{says}'" end
  end
end

specification "A developer may succinctly define a resource-based controller-view chain." do

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


# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__), "helpers")

specification "Blackboard" do

  it 'should create a blackboard' do
    request = mock(:request)
    Waves::Blackboard.new(request).should.not == nil
  end

  it 'should allow adding a value, and reading from it' do
    request = mock(:request)
    bb = Waves::Blackboard.new(request)
    bb.test = 2
    bb.test.should == 2
    
    bb["test"].should == 2
    
    bb["test2"] = 3
    bb["test2"].should == 3
    bb.test2.should == 3
  end

  it 'should not have a value if never set' do
    request = mock(:request)
    bb = Waves::Blackboard.new(request)
    bb.never_set.should == nil
    bb["never_set"].should == nil
  end

  it 'should iterate over all defined values' do
    request = mock(:request)
    bb = Waves::Blackboard.new(request)
    bb.value1 = 1
    bb.value2 = 2
    a = []
    bb.each do |value|
      a << value
    end
    a.should == [["value1", 1], ["value2", 2]]
  end
  
end

module BlackBoardVerify
  module Controllers
    class Test
      include Waves::Controllers::Mixin
    end
  end
end

module BlackBoardVerify
  module Configurations
    module Mapping
      extend Waves::Mapping
    end
  end
end

module BlackBoardVerify
  module Helpers
    module Test
      extend Waves::Helpers::BuiltIn
    end
  end
end

module BlackBoardVerify
  module Views
    module Test
      extend Waves::Views::Mixin
    end
  end
end

specification "Blackboard included in other classes" do

  before do
  end

  after do
  end

  it 'should be included in other classes' do
    request = mock(:request)
    BlackBoardVerify::Controllers::Test.instance_methods.should.include "blackboard"
    Waves::Helpers::BuiltIn.instance_methods.should.include "blackboard"
    BlackBoardVerify::Views::Test.methods.should.include "blackboard"
  end

end

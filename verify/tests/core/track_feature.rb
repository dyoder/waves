# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

describe "Feature requests" do
  
  describe "Waves.main" do
    
    it "defines a method to access the logger" do
      Waves.main.logger.should == Waves::Logger
    end
    
  end
  
end
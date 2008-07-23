# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

describe "Feature requests" do
  
  describe "Waves.application" do
    
    it "defines a method to access the logger" do
      Waves.application.logger.should == Waves::Logger
    end
    
  end
  
end
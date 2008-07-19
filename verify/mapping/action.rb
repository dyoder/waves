# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

describe "An anonymous action mapping"  do
  
  it "does things" do
    mapping.module_eval do
      action( :get => [ :resources ] ) { "Brainy" }
    end
    
    request.get("/smurf").body.should == "Brainy"
  end
  
end
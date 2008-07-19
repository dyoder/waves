# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

describe "A named action mapping"  do
  
  before do
    mapping.clear
    @resource = mock('resource')
    ResourceMappingApp::Resources::Default.stub!(:new).and_return(@resource)
  end
  
  it "calls the method with the action name on the Resource" do
    @resource.should.receive(:smurf)
    mapping.action( :smurf, :get => [ "blue_critter" ] )
    
    request.get("/blue_critter").status.should == 200
  end
  
  
end

describe "An anonymous action mapping" do
  
  before do
    mapping.clear
  end
  
  it "raises an ArgumentError when no block is supplied" do
    lambda { mapping.action( :get => [ "one" ] ) }.should.raise ArgumentError
  end
  
  it "uses the supplied block" do
    mapping.action( :get => [ "two" ] ) { "Brainy" }
    
    request.get("/two").body.should == "Brainy"
  end
  
end
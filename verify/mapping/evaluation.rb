# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

# N.B.  All of these specs require that the dispatcher actually work.  Unit testing somewhere else
# will help prevent mysterious spec failures or regressions.

describe "A mapping declaration"  do
  
  before do
    mapping.clear
    handle( Waves::Dispatchers::NotFoundError ) { response.status = 404 }
    @resource = mock('resource')
    @default = ResourceMappingApp::Resources::Default
    
  end
  
  it "operates on app::Resources::Default when a resource is not specified" do
    mapping.response( :mapping_name, :get => [ "somewhere"] ) do
      self.class.inspect
    end
    
    mock_request.get("/somewhere").body.should == "ResourceMappingApp::Resources::Default"
  end
  
  it "may specify a resource in the options with a key of :resource" do
    mapping.response( :mapping_name, :resource => :smurf, :get => [ "somewhere"] ) do
      self.class.inspect
    end
    
    mock_request.get("/somewhere").body.should == "ResourceMappingApp::Resources::Smurf"
  end
  
  it "may determine the resource using a parameter match in the path pattern" do
    mapping.response( :mapping_name, :get => [ :resources ]) { self.class.inspect }
    mapping.response( :mapping_name, :get => [ :resource ]) { self.class.inspect }
    
    mock_request.get("/blankets").body.should == "ResourceMappingApp::Resources::Blanket"
    mock_request.get("/blanket").body.should == "ResourceMappingApp::Resources::Blanket"
  end
  
end

describe "A mapping given a name as the first argument" do
  
  before do
    mapping.clear
    handle( Waves::Dispatchers::NotFoundError ) { response.status = 404 }
    @resource = mock('resource')
    @default = ResourceMappingApp::Resources::Default
  end
  
  it "calls the method with the action name on the Resource" do
    @default.stub!(:new).and_return(@resource)
    @resource.should.receive(:smurf)
    mapping.response( :smurf, :get => [ "blue_critter" ] )
    
    mock_request.get("/blue_critter").status.should == 200
  end
  
  it "defines a method on the Resource when a block is given" do
    mapping.response( :gargamel, :get => [ "wizard" ] ) { "Kill Smurfs!" }
    
    @default.new( mock('request') ).should.respond_to :gargamel
  end
  
  it "defines a path generator on the Resource's Paths object" do
    mapping.response( :gargamel, :get => [ "wizard" ] ) { "Kill Smurfs!" }
    
    @default.new( mock('request') ).paths.should.respond_to :gargamel
  end
  
end

describe "A mapping without a name" do
  
  before do
    mapping.clear
    handle( Waves::Dispatchers::NotFoundError ) { response.status = 404 }
  end
  
  it "raises an ArgumentError when no block is supplied" do
    lambda { mapping.response( :get => [ "one" ] ) }.should.raise ArgumentError
  end
  
  it "evaluates the supplied block instead of calling a resource method" do
    mapping.response( :get => [ "two" ] ) { "Brainy" }
    
    mock_request.get("/two").body.should == "Brainy"
  end
  
end
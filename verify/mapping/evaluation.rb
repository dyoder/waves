# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

# N.B.  All of these specs require that the dispatcher actually work.  Unit testing somewhere else
# will help prevent mysterious spec failures or regressions.

describe "A mapping declaration"  do
  
  before do
    mappings.clear
    handle( Waves::Dispatchers::NotFoundError ) { response.status = 404 }
    @default = MappingApp::Resources::Default
    
  end
  
  it "operates on the default resource when a resource is not specified" do
    mappings do
      on( :get => [ "somewhere"] ) { resource }
    end
    
    mock_request.get("/somewhere").body.should == "default"
  end
  
  it "may specify a resource in the options with a key of :resource" do
    mappings do
      on( :get => [ "somewhere"], :resource => :smurf ) { self.class.inspect }
    end
    
    mock_request.get("/somewhere").body.should == "MappingApp::Resources::Smurf"
  end
  
  it "may determine the resource using a parameter match in the path pattern" do
    
    mappings do
      on( :get => [ :resource ]) { resources }
      on( :get => [ "some", :resources ]) { singular }
    end
    
    mock_request.get("/blanket").body.should == "blankets"
    mock_request.get("/some/blankets").body.should == "blanket"
  end
  
end

describe "A mapping with an :as param" do
  
  before do
    mappings.clear
    handle( Waves::Dispatchers::NotFoundError ) { response.status = 404 }
    @resource = mock('resource')
    @default = MappingApp::Resources::Default
  end
  
  it "calls the method with the action name on the Resource when no block is supplied" do
    @default.stub!(:new).and_return(@resource)
    @resource.should.receive(:smurf).and_return("Smurfy")
    mappings do
      on( :get => [ "blue_critter" ], :as => :smurf )
    end
    
    mock_request.get("/blue_critter").body.should == "Smurfy"
    
    mappings.clear
    @resource.should.not.receive(:leprechaun)
    mappings do
      on( :get => [ "green_critter" ], :as => :leprechaun ) { "Gold!" }
    end
    
    mock_request.get("/green_critter").body.should == "Gold!"
  end
  
  
  it "defines a path generator on the Resource's Paths object" do
    mappings do
      on( :get => [ :wizard ], :as => :wizard ) { "Kill Smurfs!" }
    end
    
    paths = @default.new( mock('request') ).paths
    paths.should.respond_to :wizard
  end
  
end

describe "A mapping without a name" do
  
  before do
    mappings.clear
    handle( Waves::Dispatchers::NotFoundError ) { response.status = 404 }
  end
  
  it "raises an ArgumentError when no block is supplied" do
    lambda do
      mappings { on( :get => [ "one" ] ) }
    end.should.raise ArgumentError
  end
  
  it "evaluates the supplied block instead of calling a resource method" do
    mappings do
      on( :get => [ "two" ] ) { "Brainy" }
    end
    
    mock_request.get("/two").body.should == "Brainy"
  end
  
end
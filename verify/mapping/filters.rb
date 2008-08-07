# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

# N.B.  All of these specs require that the dispatcher actually work.  Unit testing somewhere else
# will help prevent mysterious spec failures or regressions.

STATE = []

describe "A before filter"  do
  
  before do
    mapping.clear    
    mapping.response( :get => [ "somewhere" ] ) { "main" }
  end
  
  it "is evaluated before the action" do
    mapping.before( :mapping_name, :get => [ "somewhere"] ) do
      response.body << "before, "
    end
    
    mock_request.get("/somewhere").body.should == "before, main"
  end
  
end

describe "An after filter"  do
  
  before do
    STATE[0] = "foo"
    mapping.clear    
    handle( ArgumentError ) { response.status = 404 }
    mapping.response( :get => [ "somewhere" ] ) { "main" }
  end
  
  it "is evaluated after the action" do
    mapping.after( :mapping_name, :get => [ "somewhere"] ) do
      response.body << ", after"
    end
    
    mock_request.get("/somewhere").body.should == "main, after"
  end
  
  it "is not evaluated if the action raises an exception" do
    mapping.response( :get => [ "elsewhere" ] ) { raise ArgumentError }
    mapping.after( :mapping_name, :get => [ "elsewhere"] ) do
      STATE[0] = "bar"
    end
    
    mock_request.get("/elsewhere")
    STATE[0].should == "foo"
  end
  
end

describe "An always filter"  do
  
  before do
    STATE[0] = "foo"
    mapping.clear
    handle( ArgumentError ) { response.status = 404 }
    
    mapping.response( :get => [ "somewhere" ] ) { raise ArgumentError }
  end
  
  it "is evaluated no matter what horrible things may happen in the action" do
    mapping.always( :mapping_name, :get => [ "somewhere"] ) do
      STATE[0] = "bar"
    end
    
    mock_request.get("/somewhere")
    STATE.should == ["bar"]
  end
  
end
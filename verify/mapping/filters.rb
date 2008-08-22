# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

# N.B.  All of these specs require that the dispatcher actually work.  Unit testing somewhere else
# will help prevent mysterious spec failures or regressions.

STATE = []

describe "A before filter"  do
  
  before do
    mappings.clear
  end
  
  it "is evaluated before the action" do
    mappings do      
      before do
        on( :get => [ "somewhere"] ) { response.body << "before, " }
        on( :get => [ true ] ) { response.body << "later, " }
      end
      on( :get => [ "somewhere" ] ) { "main" }
    end
    
    mock_request.get("/somewhere").body.should == "before, later, main"
  end
  
end

describe "An after filter"  do
  
  before do
    mappings.clear    
    handle( ArgumentError ) { response.status = 404 }
  end
  
  it "is evaluated after the action" do
    mappings do
      on( :get => [ "somewhere" ] ) { "main" }
      after do
        on(:get => [ "somewhere"] ) { response.body << ", after" }
      end
    end
    
    mock_request.get("/somewhere").body.should == "main, after"
  end
  
  # this is testing Dispatcher behavior.  Needs a rethink
  it "is not evaluated if the action raises an exception" do
    STATE[0] = "foo"
    mappings do
      on( :get => [ "elsewhere" ] ) { raise ArgumentError }
      after do
        on(:get => [ "elsewhere"] ) { STATE[0] = "bar" }
      end
    end
    
    mock_request.get("/elsewhere")
    STATE[0].should == "foo"
  end
  
end

describe "An always filter"  do
  
  before do
    STATE[0] = "foo"
    mappings.clear
    handle( ArgumentError ) { response.status = 404 }
  end
  
  # this is also testing Dispatcher behavior.
  it "is evaluated no matter what horrible things may happen in the action" do
    mappings do
      on( :get => [ "somewhere" ] ) { raise ArgumentError }
      always do
        on(:get => [ "somewhere"] ) { STATE[0] = "bar" }
      end
    end
    
    mock_request.get("/somewhere")
    STATE.should == ["bar"]
  end
  
end
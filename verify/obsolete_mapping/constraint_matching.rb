# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

describe "A mapping"  do
  
  before do
    mappings.clear
    handle( Waves::Dispatchers::NotFoundError ) { response.status = 404 }
  end
  
  it "can match the URL scheme name" do
    mappings do
      on( :scheme => 'https' ) { "Timmmah!" }
    end
    
    mock_request.get("https://www.rubywaves.com/foo").status.should == 200
    mock_request.get("http://www.rubywaves.com/foo").status.should == 404
  end
  
  it "can match the domain name" do
    mappings do
      on( :domain => 'rubywaves.com' ) { 'Timmah!'}
    end
    
    mock_request.get("http://rubywaves.com/foo" ).status.should == 200
    mock_request.get("http://www.microsoft.com/foo").status.should == 404
  end
  
  it "can match the Accepts header" do
    mappings do
      on( :accept => 'text/plain' ) { "boooring."}
    end
    
    mock_request.get("/foo", 'HTTP_ACCEPT' => 'text/plain').status.should == 200
    mock_request.get("/foo", 'HTTP_ACCEPT' => 'text/xml').status.should == 404
  end
  
  it "can use a Regexp on any of the above" do
    mappings do
      on( :accept => /image|audio/ ) { "boooring."}
    end
    
    mock_request.get("/foo", 'HTTP_ACCEPT' => 'image/jpeg').status.should == 200
    mock_request.get("/foo", 'HTTP_ACCEPT' => 'text/xml').status.should == 404
  end
  
  it "can use a lambda on any of the above" do
    mappings do
      on( :accept => lambda { |types| types.include? 'text/plain' } ) { "boooring."}
      on( :accept => lambda { |types| types.include? /image/ } ) { "cool."}
    end
    
    mock_request.get("/foo", 'HTTP_ACCEPT' => 'text/plain').status.should == 200
    mock_request.get("/foo", 'HTTP_ACCEPT' => 'image/jpeg').status.should == 200
    mock_request.get("/foo", 'HTTP_ACCEPT' => 'text/xml').status.should == 404
  end
  
end


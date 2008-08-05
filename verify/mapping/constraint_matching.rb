# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

describe "A mapping"  do
  
  before do
    mapping.clear
    handle( Waves::Dispatchers::NotFoundError ) { response.status = 404 }
  end
  
  it "can match the URL scheme name" do
    mapping.response( :scheme => 'https' ) { "Timmmah!" }
    
    mock_request.get("https://www.rubywaves.com/foo").status.should == 200
    mock_request.get("http://www.rubywaves.com/foo").status.should == 404
  end
  
  it "can match the domain name" do
    mapping.response( :domain => 'rubywaves.com' ) { 'Timmah!'}
    response = mock_request.get("http://rubywaves.com/foo" )
    response.status.should == 200
    mock_request.get("http://www.microsoft.com/foo").status.should == 404
  end
  
  it "can match the Accepts header" do
    mapping.response( :accept => 'text/plain' ) { "boooring."}
    
    mock_request.get("/foo", 'HTTP_ACCEPT' => 'text/plain').status.should == 200
    mock_request.get("/foo", 'HTTP_ACCEPT' => 'text/xml').status.should == 404
  end
  
  it "can use a Regexp on any of the above" do
    mapping.response( :accept => /image|audio/ ) { "boooring."}
    
    mock_request.get("/foo", 'HTTP_ACCEPT' => 'image/jpeg').status.should == 200
    mock_request.get("/foo", 'HTTP_ACCEPT' => 'text/xml').status.should == 404
  end
  
  it "can use a lambda on any of the above" do
    mapping.response( :accept => lambda { |types| types.include? 'text/plain' } ) { "boooring."}
    mapping.response( :accept => lambda { |types| types.include? /image/ } ) { "cool."}
    
    mock_request.get("/foo", 'HTTP_ACCEPT' => 'text/plain').status.should == 200
    mock_request.get("/foo", 'HTTP_ACCEPT' => 'image/jpeg').status.should == 200
    mock_request.get("/foo", 'HTTP_ACCEPT' => 'text/xml').status.should == 404
  end
  
end


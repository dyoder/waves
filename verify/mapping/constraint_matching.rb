# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

describe "A mapping"  do
  
  before do
    mapping.clear
    handle( Waves::Dispatchers::NotFoundError ) { response.status = 404 }
  end
  
  it "can match the URL scheme name" do
    mapping.action( :scheme => 'https' ) { "Timmmah!" }
    
    request.get("https://www.rubywaves.com/foo").status.should == 200
    request.get("http://www.rubywaves.com/foo").status.should == 404
  end
  
  it "can match the domain name" do
    mapping.action( :domain => 'rubywaves.com' ) { 'Timmah!'}
    response = request.get("http://rubywaves.com/foo" )
    response.status.should == 200
    request.get("http://www.microsoft.com/foo").status.should == 404
  end
  
  it "can match the Accepts header" do
    mapping.action( :accepts => 'text/plain' ) { "boooring."}
    request.get("/foo", 'HTTP_ACCEPT' => 'text/xml').status.should == 404
  end
  
end


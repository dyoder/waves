# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

describe "An instance of Waves::Response" do
  
  before do
    Waves::Session.stub!(:base_path).and_return(BasePath)
    @request = Waves::Request.new(env_for)
    @response = Waves::Response.new(@request)
  end
  
  it "has a Rack::Response" do
    @response.rack_response.class.should == Rack::Response
  end
  
  it "has a Waves::Request" do
    @response.request.class.should == Waves::Request
  end
  
  it "can access the session for the current request" do
    @response.session.class.should == Waves::Session
  end
  
  it "provides setter methods for commonly used headers" do
    @response.rack_response.should.receive(:[]=).with('Content-Type', 'text/javascript')
    @response.content_type = 'text/javascript'
    
    @response.rack_response.should.receive(:[]=).with('Content-Length', '42')
    @response.content_length = '42'
    
    @response.rack_response.should.receive(:[]=).with('Location', '/here/')
    @response.location = '/here/'
    
    @response.rack_response.should.receive(:[]=).with('Expires', 'Thu, 09 Aug 2007 05:22:55 GMT')
    @response.expires = 'Thu, 09 Aug 2007 05:22:55 GMT'
  end
  
  it "delegates unknown methods to the Rack response" do
    @response.rack_response.should.receive(:mclintock!)
    @response.mclintock!
  end
  
end

describe "Waves::Response#finish" do
  
  before do
    Waves::Session.stub!(:base_path).and_return(BasePath)
    @request = Waves::Request.new(env_for)
    @response = Waves::Response.new(@request)
  end
  
  it "saves the request session and calls Rack::Response#finish" do
    @response.session.should.receive(:save)
    @response.rack_response.should.receive(:finish)
    @response.finish
  end
  
end
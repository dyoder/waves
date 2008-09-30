# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

describe "A Waves request instance" do
  
  before do
    @request = Waves::Request.new(env_for("http://example.com/index.html", 'CONTENT_TYPE' => "text/html"))
  end
  
  it "has session and response objects" do
    @request.session.should.be.a.kind_of Waves::Session
    @request.response.should.be.a.kind_of Waves::Response
  end
  
  it "provides an accessor to the immutable Rack request" do
    @request.rack_request.class.should == Rack::Request
    @request.rack_request.frozen?.should == true
  end
  
  it "wraps some useful Rack data in more elegant methods" do
    @request.path.should == "/index.html"
    @request.domain.should == "example.com"
    @request.content_type.should == "text/html"
  end

  
end

describe "The HTTP request method" do
  
  before do
    @session = mock("session")
    @response = mock("response")
    Waves::Session.stub!(:new).and_return(@session)
    Waves::Response.stub!(:new).and_return(@response)
  end
  
  it "is determined in a straightforward manner for straightforward requests" do
    @get = Waves::Request.new(env_for("/", :method => 'GET'))
    @post = Waves::Request.new(env_for("/", :method => 'POST'))
    @put = Waves::Request.new(env_for("/", :method => 'PUT'))
    @delete = Waves::Request.new(env_for("/", :method => 'DELETE'))
    
    @get.method.should == :get
    @post.method.should == :post
    @put.method.should == :put
    @delete.method.should == :delete
  end
    
  it "can be set with the '_method' query param on a POST" do  
    @url_put = Waves::Request.new(env_for("/?_method=put", :method => 'POST'))
    @url_delete = Waves::Request.new(env_for("/?_method=delete", :method => 'POST'))
    
    @url_put.method.should == :put
    @url_delete.method.should == :delete
  end
    
  it "can be set with the '_method' body param on a POST" do  
    @body_put = Waves::Request.new(env_for("/", :method => 'POST', :input => '_method=put'))
    @body_delete = Waves::Request.new(env_for("/", :method => 'POST', :input => '_method=delete'))
    
    @body_put.method.should == :put
    @body_delete.method.should == :delete
  end
  
end
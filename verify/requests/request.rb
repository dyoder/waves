# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

describe "A Waves request instance" do
  
  before do
    Waves::Session.stub!(:base_path).and_return(BasePath)
    @request = Waves::Request.new(env_for("/", 'HTTP_ACCEPT' => 'text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5'))
  end
  
  it "has session, response, and blackboard objects" do
    @request.session.class.should == Waves::Session
    @request.response.class.should == Waves::Response
    @request.blackboard.class.should == Waves::Blackboard
  end
  
  it "provides an accessor to the Rack request" do
    @request.rack_request.class.should == Rack::Request
  end
  
  it "wraps some useful Rack data in more elegant methods" do
    @request.rack_request.should.receive(:path_info)
    @request.path

    @request.rack_request.should.receive(:host)
    @request.domain

    @request.rack_request.env.should.receive(:[]).with('CONTENT_TYPE')
    @request.content_type
  end
  
  it "parses the Accept header for content-types" do
    entries = ["text/xml", "application/xml", "application/xhtml+xml", "text/html", "text/plain", "image/png", "*/*"]
    @request.accept.should == entries
  end
  
  # ** API CHANGE **
  # it "delegates unknown methods to the Rack request" do
  #   @request.rack_request.should.receive(:chitty_bang_bang)
  #   @request.chitty_bang_bang
  # end
  
end

describe "The HTTP request method" do
  
  before do
    Waves::Session.stub!(:base_path).and_return(BasePath)
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
    
  # it "can be set with the '_method' query param on a POST" do  
  #   @url_put = Waves::Request.new(env_for("/?_method=put", :method => 'POST'))
  #   @url_delete = Waves::Request.new(env_for("/?_method=delete", :method => 'POST'))
  #   
  #   @url_put.method.should == :put; @url_put.put?.should.be.true
  #   @url_delete.method.should == :delete; @url_delete.delete?.should.be.true
  # end
    
  # it "can be set with the '_method' body param on a POST" do  
  #   @body_put = Waves::Request.new(env_for("/", :method => 'POST', :input => '_method=put'))
  #   @body_delete = Waves::Request.new(env_for("/", :method => 'POST', :input => '_method=delete'))
  #   
  #   @body_put.method.should == :put; @body_put.put?.should.be.true
  #   @body_delete.method.should == :delete
  # end
  
end
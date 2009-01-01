require "#{File.dirname(__FILE__)}/../helpers.rb"

describe "A Waves request instance" do
  
  before do
    @request = Waves::Request.new(env( '/', :method => 'GET' ))
  end
  
  it "has session, response, and blackboard objects" do
    @request.session.class.should == Waves::Session
    @request.response.class.should == Waves::Response
  end
  
  it "provides an accessor to the Rack request" do
    @request.rack_request.class.should == Rack::Request
  end
  
  it "wraps some useful Rack data in more elegant methods" do
    @request.path.should == "/"

    @request.domain.should == "example.org"

    # @request.content_type.should == "text/html"
  end
  
  # it "delegates unknown methods to the Rack request" do
  #   @request.chitty_bang_bang
  # end
  
end

describe "The HTTP request method" do
  
  
  it "is determined in a straightforward manner for straightforward requests" do
    @get = Waves::Request.new(env("/", :method => 'GET'))
    @post = Waves::Request.new(env("/", :method => 'POST'))
    @put = Waves::Request.new(env("/", :method => 'PUT'))
    @delete = Waves::Request.new(env("/", :method => 'DELETE'))
    
    @get.method.should == :get
    @post.method.should == :post
    @put.method.should == :put
    @delete.method.should == :delete
  end
    
  it "can be set with the '_method' query param on a POST" do  
    @url_put = Waves::Request.new(env("/?_method=put", :method => 'POST'))
    @url_delete = Waves::Request.new(env("/?_method=delete", :method => 'POST'))
    
    @url_put.method.should == :put; @url_put.put.should.be.true
    @url_delete.method.should == :delete; @url_delete.delete.should.be.true
  end
    
  it "can be set with the '_method' body param on a POST" do  
    @body_put = Waves::Request.new(env("/", :method => 'POST', :input => '_method=put'))
    @body_delete = Waves::Request.new(env("/", :method => 'POST', :input => '_method=delete'))
    
    @body_put.method.should == :put; @body_put.put.should.be.true
    @body_delete.method.should == :delete
  end
  
end
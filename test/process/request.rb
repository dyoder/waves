require 'test/helpers.rb'
require 'foundations/compact'

describe "Request Object" do
  before do
    Test = Module.new { include Waves::Foundations::Compact }
    Waves << Test
  end
  
  after do
    Waves.applications.clear
    Object.instance_eval { remove_const( :Test ) if const_defined?( :Test ) }
  end
  
  feature "Access the request method, scheme, url, host, port, path, referer, and query" do
    r = Waves::Request.new(  env( 'http://localhost/', :method => 'GET' ) )
    { :scheme => 'http', :url => 'http://localhost/', :method => :get,
      :path => '/', :host => 'localhost', :domain => 'localhost', 
      :query => {}, :params => {}, :port => 80, :referer => '/' }.
      each { |k,v| r.send( k ).should == v }
  end
  
  feature "Access the request method as a boolean" do
    Waves::Request.new(  env( '/', :method => 'GET' ) ).get.should == true
  end

  feature "Access HTTP headers as accessor methods" do
    Waves::Request.new(  env( '/', :method => 'GET', 
      'HTTP_CACHE_CONTROL' => 'no-cache' ) ).
      cache_control.should == 'no-cache'
  end

  feature "Access accept headers as Waves::Request::Accept objects" do
    Waves::Request.new(  env( '/', :method => 'GET', 
      'HTTP_ACCEPT_LANGUAGE' => 'en/us' ) ).
      accept_language.class.should == Waves::Request::Accept
  end
  
  feature "Access custom headers as methods" do
    Waves::Request.new(  env( '/', :method => 'GET', 
      'X_CUSTOM_HEADER' => 'foo' ) )[ :x_custom_header ].should == 'foo'
  end
  
  feature "Initiate redirect using #redirect" do
    lambda { 
      Waves::Request.new(  env( '/', :method => 'GET' ) ).redirect('/')
    }.should.raise( Waves::Dispatchers::Redirect )
  end
  
  feature "Raise NotFoundError using #not_found" do
    lambda { 
      Waves::Request.new(  env( '/', :method => 'GET' ) ).not_found
    }.should.raise( Waves::Dispatchers::NotFoundError )
  end

  feature "Access to content_type, media_type, and content_length" do
    r = Waves::Request.new( env( '/', :method => 'GET', 
      'CONTENT_TYPE' => 'text/plain;charset=utf-8', 'CONTENT_LENGTH' => 0 ) )
    r.content_type.should == 'text/plain;charset=utf-8'
    r.media_type.should == 'text/plain'
    r.content_length.should == 0
  end
  
  feature "Read / write traits to the request" do
    r = Waves::Request.new( env( '/', :method => 'GET' )) 
    r.traits[:foo] = 'bar'
    r.traits.foo.should == 'bar'
  end

  feature "The Rack request is frozen and cannot be modified" do
    r = Waves::Request.new( env( '/', :method => 'GET' )) 
    lambda { r.rack_request.instance_eval { @env = {} } }.should.raise( TypeError )
  end

end

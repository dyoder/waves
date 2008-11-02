require 'verify/helpers.rb'
require 'autocode'
require 'foundations/compact'
include Waves::Mocks

describe "Request Object" do
  before do
    Test = Module.new { include Waves::Foundations::Compact }
    Waves << Test
  end
  
  after do
    Waves.applications.clear
    Object.instance_eval { remove_const( :Test ) if const_defined?( :Test ) }
  end
  
  feature "Access the request method" do
    Waves::Request.new(  env( '/', :method => 'GET' ) ).method.should == :get
    Waves::Request.new(  env( '/', :method => 'GET' ) ).get.should == true
  end

  feature "Access the request path" do
    Waves::Request.new(  env( '/', :method => 'GET' ) ).path.should == '/'
  end
  
  feature "Access accept headers as Accept objects" do
    Waves::Request.new(  env( '/', :method => 'GET', 
      'HTTP_ACCEPT_LANGUAGE' => 'en/us' ) ).
      accept_language.should == ['en/us']
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
  
  feature "Delegates methods to Rack request" do
    Waves::Request.new( env( '/', :method => 'GET' ) ).scheme.should == 'http'
  end
  
  feature "Access to content_type, media_type, and content_length" do
    r = Waves::Request.new( env( '/', :method => 'GET', 
      'CONTENT_TYPE' => 'text/plain;charset=utf-8', 'CONTENT_LENGTH' => 0 ) )
    r.content_type.should == 'text/plain;charset=utf-8'
    r.media_type.should == 'text/plain'
    r.content_length.should == 0
  end
  
end

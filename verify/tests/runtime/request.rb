require 'verify/helpers.rb'
require 'autocode'
require 'foundations/compact'
include Waves::Mocks
describe "Request object" do
  before do
    Test = Module.new { include Waves::Foundations::Compact }
    Waves << Test
    @waves_request = Waves::Request.new(  env( '/', :method => 'GET', 
      'X_CUSTOM_HEADER' => 'foo', 'HTTP_ACCEPT_LANGUAGE' => 'en/us' ) )
  end
  
  after do
    Waves.applications.clear
    Object.instance_eval { remove_const( :Test ) if const_defined?( :Test ) }
  end
  
  feature "Should return right headers with http_variable" do
    @waves_request.http_variable(:accept_language).should == 'en/us'
  end
  
  feature "Should set right path" do
    (@waves_request.path).should == '/'
  end
  
  feature "Request Method should match" do
    @waves_request.method.should == :get
  end
  
  feature "should respond to method calls with header names" do
    @waves_request.x_custom_header.should == 'foo'
  end
  
  feature "redirect should raise redirect exception" do
    lambda {  @waves_request.redirect('/') }.should.raise(Waves::Dispatchers::Redirect)
  end
  
  feature "Should forward request to Rack::Request if that method is missing" do
    @waves_request.scheme.should == 'http'
  end
end

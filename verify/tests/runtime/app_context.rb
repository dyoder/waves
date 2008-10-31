require 'verify/helpers.rb'
require 'autocode'
require 'foundations/compact'
require 'ruby-debug'
include Waves::Mocks
describe "Application context should define request, response, params objects" do
  before do 
    Test = Module.new { include Waves::Foundations::Compact }
    Test::Resources::Map.module_eval do
      on( :get ) { to(CallMe) }
    end
    Test::Resources.module_eval do
      const_set( 'CallMe', Class.new do
                   include Waves::Resources::Mixin
                   on(:get) { 'get' }
                 end )
    end
    Waves << Test
  end
  
  after do
    
  end
  
  feature "Should define request,response and params object" do
    DEFAULT_ENV['request_uri'] = 'http://localhost/'
    DEFAULT_ENV['rack.request.query_string'] = 'a=1&b=2'
    DEFAULT_ENV["rack.request.form_hash"] = DEFAULT_ENV['rack.input'] = DEFAULT_ENV['rack.request.form_input'] = { }
    resource = Test::Resources::CallMe.new( Waves::Request.new( DEFAULT_ENV ) )
    resource.instance_eval {  request.class }.should == Waves::Request
    resource.instance_eval {  response.class }.should == Waves::Response
    Test::Resources::Map.module_eval { on( :get, [ :foo ] ) { captured[:foo] } }
    resource.instance_eval { params.nil? }.should == false
  end
  
end

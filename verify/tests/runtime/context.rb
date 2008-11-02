require 'verify/helpers.rb'
require 'autocode'
require 'foundations/compact'
include Waves::Mocks
describe "Application Context" do
  before do 
    Test = Module.new { include Waves::Foundations::Compact }
    Test::Resources::Map.module_eval { on( :get ) { to(CallMe) } }
    Test::Resources.module_eval { const_set( 'CallMe', Class.new { 
      include Waves::Resources::Mixin ; on(:get) {} } ) }
    Waves << Test
  end
  
  after do
    Waves.applications.clear
    Object.instance_eval { remove_const( :Test ) if const_defined?( :Test ) }
  end
  
  feature "Provide acccess to request, response, params, and session objects" do
    resource = Test::Resources::CallMe.new( Waves::Request.new( env('/', :method => 'GET' ) ) )
    resource.instance_eval {  request.class }.should == Waves::Request
    resource.instance_eval {  response.class }.should == Waves::Response
    resource.instance_eval { query.class }.should == Waves::Request::Query
    resource.instance_eval { session.class }.should == Waves::Session
  end
  
end

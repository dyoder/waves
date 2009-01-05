require "#{File.dirname(__FILE__)}/../../test/helpers.rb"
require 'foundations/compact'

describe "Query, Captured, and Params" do
    
  before do
    Test = Module.new { include Waves::Foundations::Compact }
    Waves << Test
  end
  
  after do
    Waves.applications.clear
    Object.instance_eval { remove_const(:Test) if const_defined?(:Test) }
  end
    
  feature "Params should combined captured and query" do 
    Test::Resources::Map.on( :get, [ :foo ] ) {}
    r = Test::Resources::Map.new( Waves::Request.new( env('http://localhost/baz?bar=7', :method => 'GET' ) ) )
    r.get ; r.captured.to_h.should == { 'foo' => 'baz' }; r.query.to_h.should == { 'bar' => '7' }
    r.params.to_h.should == { 'foo' => 'baz', 'bar' => '7' }
  end
  
end
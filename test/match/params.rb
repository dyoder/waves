require 'test/helpers.rb'
require 'waves/foundations/compact'

describe "A resource that has matched a request" do

  before do
    Test = Module.new { include Waves::Foundations::Compact }
    Waves << Test

    @request = Waves::Request.new( env('http://localhost/baz?bar=7', :method => 'GET' ) )
    Test::Resources::Map.on( :get, [ :foo ] ) {}
    @resource = Test::Resources::Map.new( @request )
    @resource.get
  end

  after do
    Waves.applications.clear
    Object.instance_eval { remove_const(:Test) if const_defined?(:Test) }
  end

  it "makes parameters captured from the path available as #captured" do
    @resource.captured.to_h.should == { 'foo' => 'baz' }
  end

  it "makes http query parameters available as #query" do
    @resource.query.to_h.should == { 'bar' => '7' }
  end

  it "provides access to all derived parameters using #params" do
    @resource.params.to_h.should == { 'foo' => 'baz', 'bar' => '7' }
  end

end

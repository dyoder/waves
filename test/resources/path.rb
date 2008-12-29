require "#{File.dirname(__FILE__)}/../../test/helpers.rb"
require "foundations/compact"

describe "A path generation method" do
  
  before do
    Test = Module.new { include Waves::Foundations::Compact } unless defined? Test
    @resource_class = Test::Resources::Map
    @paths = @resource_class.new( Waves::Request.new( env( '/', :method => 'GET' ) ) ).paths
  end
  
  after do
    Object.instance_eval { remove_const(:Test) if const_defined?(:Test) }
  end
  
  it "reproduces strings from the path template" do
    @resource_class.on(:get, :list => [ 'taller', 'ghost', 'walt' ] ) { nil }
    @paths.list.should == "/taller/ghost/walt"
  end
  
  it "treats symbols as locations for arg interpolation" do
    @resource_class.on(:get, :show => [ 'hi', 'there', :nickname ]) { nil }
    @paths.show( 'freckles' ).should == "/hi/there/freckles"
  end
  
  it "treats a hash with string or symbol value as location for arg interpolations" do
    @resource_class.on(:get, :edit => [ 'form', { :filter => 'textile' } ] ) { nil }
    @paths.edit( 'markdown' ).should == "/form/markdown"
  end
  
  it "uses a hash with regex for arg interpolation only when the arg matches the regex" do
    @resource_class.on(:get, :edit => [ 'form', { :filter => /^(textile|markdown|plain)$/ } ] ) { nil }
    @paths.edit( 'markdown' ).should == "/form/markdown"
    
    lambda { @paths.edit( 'html' ) }.should.raise ArgumentError
  end
  
  it "appends all arguments to the path when it encounters a true" do
    @resource_class.on(:get, :count_1 => [ 'first', true ]) { nil }
    @paths.count_1("second", "third", "fourth").should == "/first/second/third/fourth"
    
    @resource_class.on(:get, :count_2 => [ 'first', { :whatever => true } ]) { nil }
    @paths.count_2("second", "third", "fourth").should == "/first/second/third/fourth"
  end
  
  it "uses hash element value as default in absence of argument" do
    @resource_class.on(:get, :edit => [ 'form', { :filter => 'textile' } ] ) { nil }
    @paths.edit.should == "/form/textile"
  end
  
  it "uses regexes for argument interpolation if the arg matches" do
    @resource_class.on(:get, :list => [ "episode", /\d+/ ] ) { nil }
    @paths.list( 815 ).should == "/episode/815"
    
    lambda { path = @paths.list( "boar" ) }.should.raise ArgumentError
  end
  
end
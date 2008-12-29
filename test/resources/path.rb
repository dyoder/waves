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
  
  it "turns an empty template into '/'" do
    @resource_class.on(:get, :list => [] ) { nil }
    @paths.list.should == "/"
    @paths.list("foo").should == "/"
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
  
  it "interpolates for a hash-with-regex only when the arg matches the regex" do
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
  
  describe "given an (implicit) array of args" do
    
    it "interpolates its arguments in order" do
      @resource_class.on(:get, :list => [ :one, :two, :three ] ) { nil }
      @paths.list( 'one', 'two', 'three').should == '/one/two/three'
    end
    
  end
  
  describe "given an argument hash" do
    
    it "interpolates arg pairs that match symbols in the template" do
      @resource_class.on(:get, :list => [ :one, :two, :three ] ) { nil }
      @paths.list( :three => 'three', :one => 'one', :two => 'two').should == '/one/two/three'
    end
    
    it "interpolates arg pairs that match the keys of hashes in the template" do
      @resource_class.on(:get, :show => [ {:foo => 'bar'} ] ) { nil }
      @paths.show( :foo => 'bear' ).should == "/bear"
    end
    
    it "interpolates an arg pair for a hash-with-regex only when the arg matches the regex" do
      @resource_class.on(:get, :show => [ {:foo => /^ba(r|z|t)$/ } ] ) { nil }
      @paths.show( :foo => 'baz' ).should == "/baz"
    end

    it "raises when not all necessary interpolations can be performed" do
      @resource_class.on(:get, :list => [ :one, :two, :three ] ) { nil }
      lambda { @paths.list( :three => 'three', :one => 'one') }.should.raise ArgumentError
    end

    it "raises an ArgumentError if the template contains a regex" do
      @resource_class.on(:get, :list => [ /anything/ ] ) { nil }
      lambda { @paths.list( :one => 'one' ) }.should.raise ArgumentError
    end
    
    it "appends value/s of arg pair matching a template hash-with-true" do
      @resource_class.on(:get, :list => [ :kind, { :parts => true } ]) { nil }
      lambda { @paths.list( :kind => 'ghost') }.should.raise ArgumentError
      @paths.list( :kind => 'ghost', :parts => "walt" ).should == "/ghost/walt"
      @paths.list( :kind => 'ghost', :parts => ["walt", "boone"]).should == "/ghost/walt/boone"
    end
    
    it "raises an ArgumentError if the template contains a true" do
      @resource_class.on(:get, :list => [ :kind, true ]) { nil }
      lambda { @paths.list( :kind => 'whuh?' ) }.should.raise ArgumentError
      
    end
    
  end

  


  
end
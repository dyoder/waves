require 'verify/helpers.rb'
require 'autocode'
require 'foundations/compact'

describe "Matching Request URIs" do
    
  before do
    Test = Module.new { include Waves::Foundations::Compact }
    Waves << Test
  end
  
  after do
    Waves.applications.clear
    Object.instance_eval { remove_const(:Test) if const_defined?(:Test) }
  end

  feature "By default, we match an arbitrary path." do 
    Test::Resources::Map.module_eval { on( :get ) {} }
    get("/foobar").status.should == 200
    get("/foo/bar").status.should  == 200
  end
    
  feature "A path of true matches an arbitrary path." do 
    Test::Resources::Map.module_eval { on( :get, true ) { request.path } }
    get("/foobar").body.should == '/foobar'
    get("/foo/bar").body.should == '/foo/bar'
  end

  feature "An empty path matches root." do 
    Test::Resources::Map.module_eval { on( :get, [] ) { request.path } }
    get("/").body.should == '/'
  end
  
  feature "A string path component matches that string." do 
    Test::Resources::Map.module_eval { on( :get, [ 'foo' ] ) { request.path } }
    get("/foo").body.should == '/foo'
    get("/bar").status.should == 404
  end

  feature "A symbol path component captures that component using the symbol as a key." do 
    Test::Resources::Map.module_eval { on( :get, [ :foo ] ) { captured[:foo] } }
    get("/foo").body.should == 'foo'
    get("/bar").body.should == 'bar'
  end

  feature "A regexp path component matches the any component that matches the regexp." do 
    Test::Resources::Map.module_eval { on( :get, [ /\d+/ ] ) { request.path } }
    get("/1234").body.should == '/1234'
    get("/foo").status.should == 404
  end

  feature "A path component of true matches the remaining path." do 
    Test::Resources::Map.module_eval { on( :get, [ 'foo', true ] ) { request.path } }
    get("/foo/bar/baz").body.should == '/foo/bar/baz'
    get("/foo").status.should == 404
  end

  [["one or more", 1..-1, false, true, true],
   ["zero or more", 0..-1, true, true, true],
   ["one to N (N=2)", 1..2, false, true, true, false],
   ["one to N (N=3)", 1..3, false, true, true, true, false]
  ].each do |name, range, *tests|
    feature "A Range path component can match #{name} components" do
      Test::Resources::Map.module_eval { on(:get, ['foo', range]) { request.path } }
      tests.size.times do |i|
       get("/foo" * ( i + 1 ) ).status.should == (tests[i] ? 200 : 404)
      end
    end
  end
  
  feature "A path component can use a hash with a value of true to capture the remaining path." do 
    Test::Resources::Map.module_eval { on( :get, [ 'foo', { :rest => true }  ] ) { captured[:rest] * ' ' } }
    get("/foo/bar/baz").body.should == 'bar baz'
  end

  [["one or more", 1..-1, false, 'foo', 'foo foo'],
   ["zero or more", 0..-1, '', 'foo', 'foo foo'],
   ["one to N (N=2)", 1..2, false, 'foo', 'foo foo', false],
   ["one to N (N=3)", 0..3, '', 'foo', 'foo foo', 'foo foo foo', false]
  ].each do |name, range, *tests|
    feature "A Range path component can match #{name} components" do
      Test::Resources::Map.module_eval { on(:get, ['foo', { :rest => range }]) { captured.rest * ' ' } }
      tests.size.times do |i|
        response = get("/foo" * ( i + 1 ) )
        tests[i] ? response.body.should == tests[i] : response.status.should == 404
      end
    end
  end
  
  feature "A path component can use a hash with a string value to provide a default." do 
    Test::Resources::Map.module_eval { on( :get, [ 'foo', { :bar => 'bar' }  ] ) { captured[:bar] } }
    get("/foo/baz").body.should == 'baz'
    get("/foo").body.should == 'bar'
  end

  feature "A path component can use a hash with a regexp value to match and capture." do 
    Test::Resources::Map.module_eval { on( :get, [ 'foo', { :bar => /\d+/ }  ] ) { captured[:bar] } }
    get("/foo/123").body.should == '123'
    get("/foo").status.should == 404
  end
  
end
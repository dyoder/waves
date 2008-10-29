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

  feature "No path matches an arbitrary path." do 
    Test::Resources::Map.module_eval { on( :get ) { request.path } }
    get("/foobar").body.should == '/foobar'
    get("/foo/bar").body.should == '/foo/bar'
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

end
require 'test/helpers.rb'
require 'foundations/compact'

describe "Matching Query Parameters" do
    
  before do
    Test = Module.new { include Waves::Foundations::Compact }
    Waves << Test
  end
  
  after do
    Waves.applications.clear
    Object.instance_eval { remove_const(:Test) if const_defined?(:Test) }
  end
    
  feature "Test for a query parameter using true" do 
    Test::Resources::Map.module_eval { on( :get, true, :query => { :bar => true }) {} }
    get("/foo?bar=baz").status.should == 200
    get("/foo").status.should == 404
  end
  
  feature "Test that a query parameter matches a regexp" do 
    Test::Resources::Map.module_eval { on( :get, true, :query => { :bar => /\d+/ }) {} }
    get("/foo?bar=123").status.should == 200
    get("/foo?bar=baz").status.should == 404
  end

  feature "Test that a query parameter matches a string" do 
    Test::Resources::Map.module_eval { on( :get, true, :query => { :bar => '123' }) {} }
    get("/foo?bar=123").status.should == 200
    get("/foo?bar=baz").status.should == 404
  end

  feature "Test that a query parameter satisfies a lambda condition" do 
    Test::Resources::Map.module_eval { on( :get, true, :query => { :bar => lambda { |x| x == '123' } }) {} }
    get("/foo?bar=123").status.should == 200
    get("/foo?bar=baz").status.should == 404
  end

end
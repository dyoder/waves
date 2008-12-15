require 'test/helpers.rb'
require 'waves/foundations/compact'

describe "Matching The Accepts Header" do
    
  before do
    Test = Module.new { include Waves::Foundations::Compact }
    Waves << Test
  end
  
  after do
    Waves.applications.clear
    Object.instance_eval { remove_const(:Test) if const_defined?(:Test) }
  end
    
  feature "Match an implied accept header using the file extension" do 
    Test::Resources::Map.module_eval { on( :get, true, :accept => :javascript ) {} }
    get("/foo.js").status.should == 200
    get("/foo").status.should == 404
  end
  
  feature "Match against an array of options" do 
    Test::Resources::Map.module_eval { on( :get, true, :accept => [ :javascript, :css ] ) {} }
    get("/foo.js").status.should == 200
    get("/foo").status.should == 404
  end

  feature "Match against a Mime type (rather than subtype)" do 
    Test::Resources::Map.module_eval { on( :get, true, :accept => :image ) {} }
    get("/foo.png").status.should == 200
    get("/foo").status.should == 404
  end

end

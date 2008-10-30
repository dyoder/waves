require 'verify/helpers.rb'
require 'autocode'
require 'foundations/compact'

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
    Test::Resources::Map.module_eval { on( :get, true, :accepts => :js ) { request.path } }
    get("/foo.js").body.should == '/foo.js'
  end
  
end
require 'verify/helpers.rb'
require 'autocode'
require 'foundations/compact'

describe "Request Matching" do
    
  before do
    Test = Module.new { include Waves::Foundations::Compact }
    Test::Resources::Map.module_eval do
      on( :get ) { 'get' }
      on( :put ) { 'put' }
      on( :post ) { 'post' }
      on( :delete ) { 'delete' }
      on( :head ) { 'head' }
    end
    Waves << Test
  end
  
  after do
    Waves.applications.clear
    Object.instance_eval { remove_const(:Test) if const_defined?(:Test) }
  end
    
  feature "Match the GET method" do 
    get("/").body.should == 'get'
  end
  feature "Match the PUT method" do 
    put("/").body.should == 'put'
  end
  feature "Match the POST method" do 
    post("/").body.should == 'post'
  end
  feature "Match the DELETE method" do 
    delete("/").body.should == 'delete'
  end
  feature "Match the HEAD method" do 
    head("/").body.should == 'head'
  end
  
end
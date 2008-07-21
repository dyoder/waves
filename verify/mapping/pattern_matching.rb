# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

describe "In a mapping's path-matcher"  do
  
  before do
    mapping.clear
    handle( Waves::Dispatchers::NotFoundError ) { response.status = 404 }
  end
  
  describe "the HTTP method" do
  
    it "is specified with a hash key" do
      mapping.action( :get => [ 'somewhere' ] )     { "GET method" }
      mapping.action( :put => [ 'somewhere' ] )     { "PUT method" }
      mapping.action( :post => [ 'somewhere' ] )    { "POST method" }
      mapping.action( :delete => [ 'somewhere' ] )  { "DELETE method" }
    
      request.get("/somewhere").body.should == "GET method"
      request.put("/somewhere").body.should == "PUT method"
      request.post("/somewhere").body.should == "POST method"
      request.delete("/somewhere").body.should == "DELETE method"
    end
    
  end
  
  describe "the request path pattern" do
    
    before do
      mapping.clear
      handle( Waves::Dispatchers::NotFoundError ) { response.status = 404 }
    end
  
    it "is an array given as the value of the HTTP method key" do
      mapping.action( :get => [ 'foo' ] )  { 'The Foo' }
      mapping.action( :get => [ 'bar' ] )  { 'The Bar' }
      
      request.get('/foo').body.should == 'The Foo'
      request.get('/bar').body.should == 'The Bar'
    end
    
    it "may be omitted to allow matching all paths" do
      mapping.action( {} )  { "pathless" }
      
      request.get('/bogus').body.should == 'pathless'
    end
    
    it "may match string literals" do
      mapping.action( :get => [ 'kilroy', 'was', 'here'] )  { 'Hello from Kilroy' }
      
      request.get('/kilroy/was/here').body.should == 'Hello from Kilroy'
      
      # doesn't work for partial matches.
      request.get('/kilroy/was').status.should == 404
    end
    
    it "may use symbols as placeholders for a default regex" do
      mapping.action( :get => [ :critter ]) { params['thing']}
      request.get('/smurf').body.should == 'smurf'
    end
    
  end
  
end
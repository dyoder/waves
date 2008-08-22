# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

describe "In a mapping's path-matcher"  do
  
  describe "the HTTP method" do
    
    before do
      mappings.clear
      handle( Waves::Dispatchers::NotFoundError ) { response.status = 404 }
    end
  
    it "is specified with a hash key" do
      mappings do
        on( :get => [ 'somewhere' ] )     { "GET method" }
        on( :put => [ 'somewhere' ] )     { "PUT method" }
        on( :post => [ 'somewhere' ] )    { "POST method" }
        on( :delete => [ 'somewhere' ] )  { "DELETE method" }
        on( :any => [ 'anywhere' ] )  { "Whatever" }
      end

    
      mock_request.get("/somewhere").body.should == "GET method"
      mock_request.put("/somewhere").body.should == "PUT method"
      mock_request.post("/somewhere").body.should == "POST method"
      mock_request.delete("/somewhere").body.should == "DELETE method"
      
      mock_request.get("/anywhere").body.should == "Whatever"
      mock_request.post("/anywhere").body.should == "Whatever"
    end
    
  end
  
  describe "the request path pattern" do
      
      before do
        mappings.clear
        handle( Waves::Dispatchers::NotFoundError ) { response.status = 404 }
      end
    
      it "is an array given as the value of the HTTP method key" do
        mappings do
          on( :get => [ 'foo' ] )  { 'The Foo' }
          on( :get => [ 'bar', 'baz' ] )  { 'The Bar' }
        end
        
        mock_request.get('/foo').body.should == 'The Foo'
        mock_request.get('/bar/baz').body.should == 'The Bar'
      end
      
      it "may be omitted to allow matching all paths" do
        mappings do
          on( {} )  { "pathless" }
        end
        
        mock_request.get('/bogus').body.should == 'pathless'
      end
      
      it "may use true to match all paths, while specifying a method" do
        mappings do
          on( :get => [ true ] ) { "pathless" }
        end
        
        mock_request.get('/bogus').body.should == 'pathless'
      end
      
      it "may use true as the last element, to match all remaining components" do
        mappings do
          on( :get => [ "first", true ] ) { "Yes" }
        end
        
        mock_request.get('/first/second/third').body.should == "Yes"
        mock_request.get('/uno/dos/tres').status.should == 404
      end
      
      it "may match string literals" do
        mappings do
          on( :get =>  %w{ kilroy was here } )  { 'Hello from Kilroy' }
        end
        
        mock_request.get('/kilroy/was/here').body.should == 'Hello from Kilroy'
        
        # prove it doesn't work for partial matches.
        mock_request.get('/kilroy/was').status.should == 404
      end
      
      it "may use symbols as placeholders for a default regex" do
        mappings do
          on( :get => [ :critter, :name ] ) { "hi" }
        end
        
        mock_request.get('/smurf/papa_smurf').status.should == 200
        
      end
      
      it "may use hashes to specify placeholders with custom regexes" do
        mappings do
          on( :get => [ "prisoner", { :prisoner_id => /9430|24601/ } ] ) { "I am Jean Valjean!" }
        end
        
        mock_request.get("/prisoner/9430").body.should == "I am Jean Valjean!"
        mock_request.get("/prisoner/9431").status.should == 404
      end
      
      it "may use hash placeholder with value of true, to glom up all remaining components" do
        mappings do
          on( :get => [ :first, { :rest => true } ] ) do
            [ params['first'], params['rest'].join('-') ].join(', ')
          end
        end
        
        mock_request.get("/one/two/three/four").body.should == "one, two-three-four"
      end
      
      it "saves placeholder matches as params" do
        mappings do
          on( :get => [ :critter, :name ]) { "#{params['critter']}, #{params['name']}" }
        end
        
        mock_request.get('/dwarf/tyrion').body.should == "dwarf, tyrion"
      end
      
      it "may use regexes instead of strings or placeholders, but the matches are not saved" do
        # extremely bad example.  Don't ever really use this for authentication.  If somebody thinks up a
        # better use case for pattern components that throw away the matches, please fix this spec.
        mappings do
          on( :get => [ "user", /matthew|mark/, "password", /wehttam|kram/ ]) { "you been let in"}
        end
        
        mock_request.get('/user/matthew/password/wehttam').status.should == 200
        mock_request.get('/user/matthew/password/nimda').status.should == 404
      end
      
      it "can apparently also use hashes to set default values" do
        mappings do
          on( :get => [ "thingy", { :mode => 'show' } ] ) { "mode: #{params['mode']}" }
        end
        
        mock_request.get("/thingy").body.should == "mode: show"
        mock_request.get("/thingy/edit").body.should == "mode: edit"
      end
      
    end
  
end

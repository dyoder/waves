# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

describe "A mapping"  do
  
  before do
    mappings.clear
    handle( Waves::Dispatchers::NotFoundError ) { response.status = 404 }
  end
  
  it "can match on query params" do
    mappings do
      on( :get => [ :somewhere ] ) do
        puts request.params.inspect
      end
    end
    
    mock_request.get("/there").status.should == 200
  end
  
end
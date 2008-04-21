# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__), "..", "helpers")

specification "A developer can handle exceptions using some damn thing" do
    
  before do
    mapping.clear
  end

  specify 'Map the path of a GET request to a lambda.' do
    r = get('/')
    r.status.should == 404
    r.body.should.be.empty
  end
  
end
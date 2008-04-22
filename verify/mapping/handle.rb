# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__), "..", "helpers")

specification "A developer can register exception handlers" do
    
  before do
    mapping.clear
  end

  specify 'The minimal 404 handler in SimpleErrors' do
    r = get('/')
    r.status.should == 404
    r.body.should.be.empty
  end
  
  specify "A custom 404 handler should override the minimal" do
    handle(Waves::Dispatchers::NotFoundError) { response.status = 404; response.body = "gone baby gone"}
    r = get('/')
    r.status.should == 404
    r.body.should == "gone baby gone"
  end
  
end
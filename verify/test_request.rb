require 'helper.rb'

context "playing with Rack::MockRequest" do
  
  before(:all) do
    @dispatcher = Waves::Dispatchers::Default.new
    @rack = Rack::MockRequest.new(@dispatcher)
  end
  
  specify "root" do
    @rack.get("/").status.should == 404
  end
  
end
require File.join(File.dirname(__FILE__), "..", 'helper.rb')

context "A developer can map requests to filters." do

  before(:all) do
    Waves::Console.load(:mode => 'development')
  end

  before(:each) do
    @dispatcher = Waves::Dispatchers::Default.new
    @rack = Rack::MockRequest.new(@dispatcher)
  end

  specify "Map a path to a 'before', 'after' and 'wrap' filters." do
    @rack.get('/filters').body.should == 'Before::Wrap:During:Wrap::After'
  end

  specify "Map a POST to a path to a 'before', 'after' and 'wrap' filters" do
    @rack.post('/filters').body.should == 'Before post:Before::Wrap post::Wrap:During:Wrap post::Wrap:After post::After'
  end

  specify "The 'before', 'after' and 'wrap' filters accept a regular expression and can extract parameters from the request path" do
    @rack.get('/filters/xyz').body.should == 'Before xyz::Wrap xyz:During:Wrap xyz::After xyz'
  end

  specify "When having 'before', 'after' and 'wrap' filters but no corresponding map action this results in a 404" do
    @rack.get('/filters_with_no_map').body.should =~ '404'
  end

end

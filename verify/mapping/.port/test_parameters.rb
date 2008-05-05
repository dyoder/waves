require File.join(File.dirname(__FILE__), "..", 'helper.rb')

context "A developer can extract parameters from a request path or URL." do
  before(:all) do
    Waves::Console.load(:mode => 'development')
  end

  before(:each) do
    @dispatcher = Waves::Dispatchers::Default.new
    @rack = Rack::MockRequest.new(@dispatcher)
  end

  specify 'Extract a parameter via a regexp match of the path.' do
    @rack.get('/param/elephant').body.should == 'You asked for: elephant.'
  end

  specify 'Extract a parameter via a regexp match of the URL.' do
    @rack.get('http://localhost:3000/port').body.should == '3000'
  end

end

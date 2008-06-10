require File.join(File.dirname(__FILE__), "..", 'helper.rb')

context "A developer can map requests using the request method." do

  before(:all) do
    Waves::Console.load(:mode => 'development')
  end

  before(:each) do
    @dispatcher = Waves::Dispatchers::Default.new
    @rack = Rack::MockRequest.new(@dispatcher)
  end

  specify 'Map the path of a GET request to a lambda.' do
    @rack.get( '/' ).body.should == 'This is a simple get rule.'
  end

  specify 'Map the path of a POST request to a lambda.' do
    @rack.post( '/' ).body.should == 'This is a simple post rule.'
  end

  specify 'Map the path of a PUT request to a lambda.' do
    @rack.put( '/' ).body.should == 'This is a simple put rule.'
  end

  specify 'Map the path of a DELETE request to a lambda.' do
    @rack.delete( '/' ).body.should == 'This is a simple delete rule.'
  end

  specify 'When method is not explicitely set in a mapping it accepts all methods' do
    @rack.get( '/foo' ).body.should == "The server says, 'bar!'"
    @rack.post( '/foo' ).body.should == "The server says, 'bar!'"
    @rack.put( '/foo' ).body.should == "The server says, 'bar!'"
    @rack.delete( '/foo' ).body.should == "The server says, 'bar!'"
  end

end

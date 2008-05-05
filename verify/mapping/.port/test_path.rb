require File.join(File.dirname(__FILE__), "..", 'helper.rb')

context "A developer can map requests using the request path." do

  before(:all) do
    Waves::Console.load(:mode => 'development')
  end

  before(:each) do
    @dispatcher = Waves::Dispatchers::Default.new
    @rack = Rack::MockRequest.new(@dispatcher)
  end

  specify 'Map the path of a GET request to a lambda.' do
    @rack.get('/').body.should == 'This is a simple get rule.'
    @rack.get('/foo').body.should.not == 'This is a simple get rule.'
  end

  specify 'Maps use a string as first parameter' do
    @rack.get('/pathstring').body.should == 'Before pathstringWrap pathstringDuring pathstringWrap pathstringAfter pathstring'
    @rack.get('/pathstring/name').body.should =~ '404'
  end

  specify 'Maps use a string as first parameter and a hash as second parameter' do
    @rack.post('/pathstring/name').body.should == 'Before pathstring postWrap pathstring postDuring pathstring postWrap pathstring postAfter pathstring post'
  end

  specify 'Maps use a regexp as first parameter' do
    @rack.get('/pathregexp').body.should == 'Before pathregexpWrap pathregexpDuring pathregexpWrap pathregexpAfter pathregexp'
    @rack.get('/pathregexp/name').body.should =~ '404'
  end

  specify 'Maps use a regexp as first parameter and a hash as second parameter' do
    @rack.post('/pathregexp/name').body.should == 'Before pathregexp postWrap pathregexp postDuring pathregexp postWrap pathregexp postAfter pathregexp post'
  end

end


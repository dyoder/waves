context "A developer can map requests using the request path." do

  specify 'Map the path of a GET request to a lambda.' do
    get('/').body.should == 'This is a simple get rule.'
    get('/foo').body.should.not == 'This is a simple get rule.'
  end

  specify 'Maps use a string as first parameter' do
    get('/pathstring').body.should == 'Before pathstringWrap pathstringDuring pathstringWrap pathstringAfter pathstring'
    get('/pathstring/name').body.should =~ '404'
  end

  specify 'Maps use a string as first parameter and a hash as second parameter' do
    post('/pathstring/name').body.should == 'Before pathstring postWrap pathstring postDuring pathstring postWrap pathstring postAfter pathstring post'
  end

  specify 'Maps use a regexp as first parameter' do
    get('/pathregexp').body.should == 'Before pathregexpWrap pathregexpDuring pathregexpWrap pathregexpAfter pathregexp'
    get('/pathregexp/name').body.should =~ '404'
  end

  specify 'Maps use a regexp as first parameter and a hash as second parameter' do
    post('/pathregexp/name').body.should == 'Before pathregexp postWrap pathregexp postDuring pathregexp postWrap pathregexp postAfter pathregexp post'
  end

end


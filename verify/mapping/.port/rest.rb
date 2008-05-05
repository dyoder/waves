context "A developer can map requests using the request method." do

  specify 'Map the path of a GET request to a lambda.' do
    get( '/' ).body.should == 'This is a simple get rule.'
  end

  specify 'Map the path of a POST request to a lambda.' do
    post( '/' ).body.should == 'This is a simple post rule.'
  end

  specify 'Map the path of a PUT request to a lambda.' do
    put( '/' ).body.should == 'This is a simple put rule.'
  end

  specify 'Map the path of a DELETE request to a lambda.' do
    delete( '/' ).body.should == 'This is a simple delete rule.'
  end

  specify 'When method is not explicitely set in a mapping it accepts all methods' do
    get( '/foo' ).body.should == "The server says, 'bar!'"
    post( '/foo' ).body.should == "The server says, 'bar!'"
    put( '/foo' ).body.should == "The server says, 'bar!'"
    delete( '/foo' ).body.should == "The server says, 'bar!'"
  end

end



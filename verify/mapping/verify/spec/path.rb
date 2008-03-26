context "A developer can map requests using the request path." do

  specify 'Map the path of a GET request to a lambda.' do
    get('/').body.should == 'This is a simple get rule.'
    get('/foo').body.should.not == 'This is a simple get rule.'
  end

end


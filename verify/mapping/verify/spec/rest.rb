context "A developer can map requests using the request method." do

  specify 'Map the path of a POST request to a lambda.' do
    post( '/' ).body.should == 'This is a simple post rule.'
  end

  specify 'Map the path of a DELETE request to a lambda.' do
    delete( '/' ).body.should == 'This is a simple delete rule.'
  end

end



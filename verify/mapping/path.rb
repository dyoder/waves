require File.join(File.dirname(__FILE__), "..", "test_helper")

specification "A developer can map requests using the request path." do
      
  before do

    use_mock_request

    path('/', :method => :post ) { 'This is a simple post rule.' }
    path('/', :method => :put ) { 'This is a simple put rule.' }
    path('/', :method => :delete ) { 'This is a simple delete rule.' }
    path('/', :method => :get) { 'This is a simple get rule.' }

  end

  specify 'Map the path of a GET request to a lambda.' do
    get('/').body.should == 'This is a simple get rule.'
  end

  specify 'Map the path of a POST request to a lambda.' do
    post('/').body.should == 'This is a simple post rule.'
  end

  specify 'Map the path of a PUT request to a lambda.' do
    put('/').body.should == 'This is a simple put rule.'
  end

  specify 'Map the path of a DELETE request to a lambda.' do
    delete('/').body.should == 'This is a simple delete rule.'
  end
  

end


require 'verify/helpers.rb'

specification "A developer can map requests using the request path." do
  
  before do
    path('/', :method => :post ) { 'This is a simple post rule.' }
    path('/', :method => :put ) { 'This is a simple put rule.' }
    path('/', :method => :delete ) { 'This is a simple delete rule.' }
    path('/', :method => :get) { 'This is a simple get rule.' }
    path('/foo') { "The server says, 'bar!'" }
    mock_request
  end

  specify 'Map the path of a GET request to a lambda.' do
    get('/').body.should == 'This is a simple get rule.'
    get('/foo').body.should.not == 'This is a simple get rule.'
  end

end


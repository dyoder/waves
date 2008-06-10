# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__), "helpers")

specification "A developer can map requests with options." do

  before do
    mapping.clear
    path('/', :remote_addr => "10.10.10.10" ) { 'This request is from 10.10.10.10' }
    path('/', :remote_addr => "127.0.0.1" ) { 'This request is from 127.0.0.1' }
  end

  specify 'Map the path of a GET request to a lambda.' do
    get('/').body.should == 'This request is from 127.0.0.1'
  end

end


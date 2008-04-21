# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__), "..", "helpers")

specification "Requests can be made threaded for event driven servers" do
      
  before do
    mapping.clear
    path( '/', :method => :post ) { 'This is a simple post rule.' }
    threaded( '/upload', {:method => :post} ) { 'This is threaded.' }
    path( '/foo' ) { "The server says, 'bar!'" }
  end

  specify 'Post to upload should be threaded' do
    req = Waves::Request.new( ::Rack::MockRequest.env_for('/upload', {:method => 'POST'}) )
    ::Waves::Dispatchers::Default.new.deferred?(req).should == true
  end

  specify 'Get to foo should not be threaded' do
    req = Waves::Request.new( ::Rack::MockRequest.env_for('/foo', {:method => 'GET'}) )
    ::Waves::Dispatchers::Default.new.deferred?(req).should == false
  end
  
end


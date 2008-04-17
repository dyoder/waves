# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__), "..", "helpers")

specification "A developer can extract parameters from a request path or URL." do
  
  before do

    use_mock_request
    
    mapping.clear
    
    path %r{/param/(\w+)} do |value|
      "You asked for: #{value}."
    end
    
    url %r{http://localhost:(\d+)/port} do |port|
      port
    end
    
  end
  
  specify 'Extract a parameter via a regexp match of the path.' do
    get('/param/elephant').body.should == 'You asked for: elephant.'
  end
  
  specify 'Extract a parameter via a regexp match of the URL.' do
    get('http://localhost:3000/port').body.should == '3000'
  end
  
end

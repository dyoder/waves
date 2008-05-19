# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__), "..", "helpers")
::TEST_VALUE = 'foo'

specification "A developer can ensure" do

  before do
    mapping.clear
    path('/' ) { raise RuntimeError.new('bar') }
    always( true ) { ::TEST_VALUE == 'bar' }
  end

  specify 'processing is guaranteed regardless of what happens in an action' do
    lambda{ get('/') }
    ::TEST_VALUE.should == 'bar'
  end

end


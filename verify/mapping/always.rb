# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__), "helpers")
::TEST_VALUE = 'foo'

specification "A developer can ensure" do

  before do
    mapping.clear
    path('/' ) { raise RuntimeError.new('bar') }
    always( true ) { Waves.been_there }
  end

  specify 'processing is guaranteed regardless of what happens in an action' do
    Waves.should.receive(:been_there)
    lambda { get('/') }.should.raise RuntimeError
  end

end


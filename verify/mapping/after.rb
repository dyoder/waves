# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__), "..", "helpers")

specification "A developer can ensure" do

  before do
    mapping.clear
    path('/' ) { raise RuntimeError.new('bar') }
    mapping.after( true ) { raise RuntimeError.new('foo')  }
  end

  specify 'processing is guaranteed regardless of what happens in an action' do
    lambda{ get('/') }.should.raise(RuntimeError).message.should == 'foo'
  end

end


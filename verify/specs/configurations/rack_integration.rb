# require 'test_helper' because RubyMate needs help
require "#{File.dirname(__FILE__)}/../../"helpers")"

describe "A Waves Configuration" do
  
  class Default < Waves::Configurations::Default; end
=begin  
  it "can specify a Rack handler" do
    class Default
      handler(::Rack::Handler::Mongrel, :Host => '0.0.0.0', :Port => 8080)
    end
    #Default.handler.should == [ ::Rack::Handler::Mongrel, { :Host => '0.0.0.0', :Port => 8080 } ]
=end

  it "provides an accessor for a hash of mime types" do
    Waves::MimeTypes.should.receive(:[]).with('foo.png').and_return('image/png')
    Default.mime_types['foo.png'].should == 'image/png'
  end
  
  it "must define the application for use with Rack" do
    app = Rack::Builder.new() {}
    Rack::Builder.should.receive(:new).with().and_return(app)
    Default.application do
      "stuff"
    end
    Default.application.should.be.a.kind_of Rack::Builder
  end
  
end
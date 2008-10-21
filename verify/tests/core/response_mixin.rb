# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

module Thingy
  module Resources
    class Hoedown; end
    class Default; end
  end
  module Controllers
    class Default

      include Waves::ResponseMixin
      attr_reader :request

      def initialize
        @request = Waves::Request.new(rack_env)
      end
      
    end
  end
end

describe "The ResponseMixin module" do
  
  before do
    @thingy = Thingy::Controllers::Default.new
  end
    
  it "defines helpers for reaching the application" do
    @thingy.app.should == Thingy
    @thingy.app_name.should == :thingy
  end

  it "defines delegators for request methods" do
    methods = [ :response, :session, :path, :url, :domain, :not_found, :traits ]
    methods.each { |method| @thingy.request.should.receive(method) }
    
    methods.each { |method| @thingy.send(method) }
  end
  
  it "delegates delegators to traits.waves" do
    methods = [ :captured, :resource ]
    methods.each { |method| @thingy.traits.waves.should.receive( method ) }
    
    methods.each { |method| @thingy.send(method) }
  end
  
  it "destructures params now" do
    # should.flunk "write a test, fool."
  end
  
  it "defines a method for accessing the present resource paths" do
    paths = mock('paths')
    paths.should.receive(:new).with(@thingy.request)
    Thingy::Resources::Default.should.receive(:paths).and_return(paths)
    @thingy.should.receive(:resource).and_return(Thingy::Resources::Default.new)
    @thingy.paths
  end
  
  it "defines a method for accessing other resources' paths" do
    paths = mock('paths')
    paths.should.receive(:new).with(@thingy.request)
    Thingy::Resources::Hoedown.should.receive(:paths).and_return(paths)
    @thingy.paths(:Hoedown)
  end
  
  it "defines a redirect method with default status code" do
    @thingy.request.should.receive(:redirect).with('/elsewhere', 301)
    @thingy.redirect("/elsewhere", 301)
  end
  
  it "defines an accessor for the logger" do
    @thingy.log.should == Waves::Logger
  end
  
end
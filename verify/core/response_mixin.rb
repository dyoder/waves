# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

# also moved model, view, controller methods for ResponseMixin to mvc layer 
# 
# all now rely on Functor and that establishes the multi-app pattern. technically the one argument versions should access the app they are defined within, but that can be incorporated later.
# http://gist.github.com/1464

module Thingy
  module Controllers
    class Default

      include Waves::ResponseMixin
      attr_reader :request

      def initialize
        @request = Waves::Request.new(Rack::MockRequest.env_for("/"))
      end
      
    end
  end
end

describe "The ResponseMixin module" do
  
  before do
    fake_out_runtime
    @thingy = Thingy::Controllers::Default.new
  end
  
  # it "defines a helper for accessing named resources" do
  #   @thingy.resource(:mookie).should == VerifyCore::Resources::Mookie
  #   @thingy.resource(:verify_core, :mookie).should == VerifyCore::Resources::Mookie
  # end
  
  it "defines helpers for reaching the application" do
    @thingy.app.should == Thingy
    @thingy.app_name.should == :thingy
  end
  
  it "defines delegators for request methods" do
    methods = [ :response, :session, :params, :path, :url, :domain, :blackboard, :not_found ]
    methods.each do |method|
      @thingy.request.should.receive(method)
    end
    
    methods.each do |method|
      @thingy.send(method)
    end
  end
  
  it "defines a delegator for the application's paths" do
    Thingy.should.receive(:paths).with(:meek)
    @thingy.paths(:meek)
  end
  
  it "defines a redirect method with default status code" do
    @thingy.request.should.receive(:redirect).with('/elsewhere', 301)
    @thingy.redirect("/elsewhere", 301)
  end
  
  it "defines an accessor for the logger" do
    @thingy.log.should == Waves::Logger
  end
  
end
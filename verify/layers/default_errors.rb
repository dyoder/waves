# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

module TestApplication
  include Waves::Foundations::Simple
  include Waves::Layers::DefaultErrors
  module Views
    module Default
    end
  end
end

Waves << TestApplication
Waves::Console.load( :mode => :development )
TA = TestApplication

include ::Waves::Verify::Helpers::Mapping
include ::Waves::Verify::Helpers::Request

describe "An application which includes the DefaultErrors layer" do
  
  it "registers a view-based handler for NotFound errors" do
    TA::Views::Default.stub!(:not_found_404).and_return("View-based 404")
    TA::Configurations::Mapping.stub!(:response).and_return(Rack::Response.new)
    req = Rack::Request.new(Rack::MockRequest.env_for('/bogus_url'))
    TA::Configurations::Mapping[req][:handlers].first[1].call.should == "View-based 404"
  end
  
end
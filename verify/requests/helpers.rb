require File.join(File.dirname(__FILE__) , "..", "helpers")

module TestRequests
  module Configurations
    class Default
      # stub!(:session).and_return(:duration => 30.minutes, :path => '/tmp/sessions')
      ::BasePath = File.dirname(__FILE__) / :tmp
      stub!(:session).and_return(:duration => 30.minutes, :path => ::BasePath)
    end
  end
  
end

def env_for(uri="/", options={})
  Rack::MockRequest.env_for(uri,options)
end
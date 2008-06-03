require File.join(File.dirname(__FILE__) , "..", "helpers")

module TestRequests
  module Configurations
    class Default
      stub!(:session).and_return(:duration => 30.minutes, :path => '/tmp/sessions')
    end
  end
  
end

Waves.application.stub!(:instance)
Waves.application.instance.stub!(:config).and_return(TestRequests::Configurations::Default)



def env_for(uri="/", options={})
  Rack::MockRequest.env_for(uri,options)
end
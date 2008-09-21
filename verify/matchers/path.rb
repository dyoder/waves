# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

Waves::Matchers::Path.module_eval do
  def matches?(request)
    self.call(request).kind_of?(Hash)
  end
end

describe "A path matcher with a single string component" do
  
  before do
    @matcher = Waves::Matchers::Path.new( [ "smurf" ] )
  end
  
  it "matches a single-component path consisting of the string" do
    @matcher.matches?(waves_request("/smurf")).should == true 
  end
  
  it "does not match a single-component path with a different string" do
    @matcher.matches?( waves_request("/bad") ).should == false
  end
  
  it "does not match a multi-component path" do
    @matcher.matches?( waves_request("/smurf/close") ).should == false
    @matcher.matches?( waves_request("/not/even/close") ).should == false
    @matcher.matches?( waves_request("/not/smurf/close") ).should == false
  end
    
  it "does not match '/' " do
    @matcher.matches?( waves_request("/")).should == false
  end
  
end

describe "A path matcher with multiple string components" do
  
  before do
    @matcher = Waves::Matchers::Path.new( [ "smurf", "pie" ] )
  end
  
  it "matches when all path components match" do
    @matcher.matches?(waves_request("/smurf/pie")).should == true
  end
  
  it "does not match unless all path components match" do
    @matcher.matches?(waves_request("/foo/bar")).should == false
    @matcher.matches?(waves_request("/smurf")).should == false
    @matcher.matches?(waves_request("/smurf/cake")).should == false
    @matcher.matches?(waves_request("/smurf/pie/filling")).should == false
    @matcher.matches?(waves_request("/filling/smurf/pie")).should == false
  end

end

describe "A path matcher with a single capture component" do
  
  before do
    @matcher = Waves::Matchers::Path.new( [ :resource ] )
  end
  
  it "matches any single-component path" do
    @matcher.matches?(waves_request("/smurf")).should == true
  end
  
end





# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

describe "A path matcher with a single string component" do
  
  before do
    @matcher = Waves::Matchers::Path.new( [ "smurf" ] )
  end
  
  it "matches a single-component url with the string" do
    @matcher.call(waves_request("/smurf")).should == {}  
  end
  
  it "does not match a single-component url with a different string" do
    @matcher.call( waves_request("/bad") ).should == nil
  end
  
  it "does not match a multi-component url with the string as the first component" do
    @matcher.call( waves_request("/smurf/close") ).should == nil
  end
  
  it "does not match a multi-component url entirely without the string" do
    @matcher.call( waves_request("/not/even/close") ).should == nil
  end
  
end

describe "A path matcher with multiple string components" do
  
  before do
    @matcher = Waves::Matchers::Path.new( [ "smurf", "pie" ] )
  end
  
  it "matches when all url components match" do
    @matcher.call(waves_request("/smurf/pie")).should == {}
  end
  
  it "does not match when no url components match" do
    @matcher.call(waves_request("/foo/bar")).should == nil
  end
  
  it "does not match when only the first component matches" do
    @matcher.call(waves_request("/smurf/cake")).should == nil
    @matcher.call(waves_request("/smurf/pie/filling")).should == nil
  end
  
end

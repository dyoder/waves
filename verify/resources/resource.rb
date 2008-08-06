# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

fake_out_runtime

describe "A Resource class" do

  before do
    class Dog < Waves::Resources::Base
      
    end
    
  end
  
  it "has a Paths object" do
    Dog.paths.should.be.a.kind_of Waves::Mapping::Paths
    Dog.paths.class.should == Waves::Resources::Base::Paths
  end
  
  it "knows singular and plural names for itself" do
    Dog.singular.should == "dog"
    Dog.plural.should == "dogs"
  end
  
end

describe "A Resource object" do
  
  before do
    
    @request = Waves::Request.new(env_for)
    @resource = VerifyResources::Resources::Dog.new(@request)
  end
  
  it "has a request" do
    @resource.request.should == @request
  end
  
  it "trusts its class for singular and plural" do
    VerifyResources::Resources::Dog.should.receive(:singular)
    VerifyResources::Resources::Dog.should.receive(:plural)
    @resource.singular; @resource.plural
  end
  
  it "can issue redirects" do
    # We should rather test the state of the response object, but currently
    # redirects are exceptions caught by the default dispatcher.  Perhaps this could
    # be extracted to an exception handler in a layer.
    lambda { @resource.redirect("/smurf") }.should.raise Waves::Dispatchers::Redirect
  end
  
end
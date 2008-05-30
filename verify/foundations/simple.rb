# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

module SimpleApplication ; include Waves::Foundations::Simple ; end

describe "An application module which includes the Simple foundation" do

  it "should have basic submodules defined" do
    lambda do
      SimpleApplication::Configurations::Mapping
      SimpleApplication::Configurations::Development
    end.should.not.raise
  end

  it "should have accessors defined" do
    [ :config, :configurations ].each do |method|
      SimpleApplication.should.respond_to method
    end
  end

  it "should define [] method for appropriate submodules" do
    SimpleApplication::Configurations.should.respond_to :[]
  end

end

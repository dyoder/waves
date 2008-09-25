# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

describe "Configuration attributes" do
  
  class Basic < Waves::Configurations::Base; end
  
  it "can be declared by developers" do
    Basic.attribute :smurf
    Basic.smurf("smurfy") 
    Basic.smurf.should == "smurfy"
  end
  
  
  it "must be declared before use" do
    Basic.should.not.respond_to :gnome
  end
  
end

describe "Waves::Configurations::Default" do
  
  class Default < Waves::Configurations::Default; end
  
  it "declares certain attributes necessary to run a Waves app" do
    %w( host port ports log reloadable database session debug root synchronize? ).each do |attr|
      Default.should.respond_to attr
    end
  end
  
  it "sets default values for important attributes" do
    [ :debug, :synchronize?, :session, :log, :reloadable ].each do |attr|
      Default[attr].should.not.be.nil
    end
  end
  
end
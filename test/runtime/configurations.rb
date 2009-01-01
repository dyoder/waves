require "#{File.dirname(__FILE__)}/../helpers.rb"
 
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
 

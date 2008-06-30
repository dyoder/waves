# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__), "helpers")

describe "A Mapping that specifies the resource in the with()" do
  
  before do
    mapping.with :resource => :smurf do
      action( :list, :get => [ 'smurves' ] ) { "smurfy" }
      action( :single, :get => [ 'smurf', :name ] ) { "not smurfy" }
    end
  end
  
  it "works miracles" do
    request.get( '/smurves' ).should == "smurfy"
  end
  
end
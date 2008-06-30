# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__), "helpers")

describe "The plural form of a resource" do
  
  it "can be specified with the :resources parameter to with()" do
    mapping.with :resource => :smurf, :resources => :smurves do
      # stuff
    end
  end
  
  it "can be specified with a grabby-thingy in the Pattern" do
    mapping.with :accepts => [ /(\w+)/ ] do
      path :list, :get => [ :resources ]
    end
  end
  
end
# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__), "helpers")

describe "A Mapping that specifies the resource in the with()" do
  
  before do
    mapping.with :resource => :smurf do
      path( :list, :get => '/smurves' ) { "smurfy" }
      path( :single, :get => '/smurf/<name>' ) { "not smurfy" }
      # path :multiple, :get => ['/smurf/<name>', '/smurf/<name>.<ext>']
    end
  end
  
  it "works miracles" do
    request.get( '/smurves' )
  end
  
end
# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

describe "A Paths class" do
  
  before do
    class TestPaths < Waves::Mapping::Paths
    end
    @resource = mock(:resource)
  end
  
  it "can define named paths using strings" do
    TestPaths.path_method(:foo, ["foo"])
    TestPaths.path_method(:bar, ["bar", "baz"])
    
    TestPaths.new(@resource).foo.should == "/foo"
    TestPaths.new(@resource).bar.should == "/bar/baz"
  end
  
  it "can define named paths using symbols as placeholders" do
    TestPaths.path_method(:list, [:things])
    TestPaths.path_method(:show, [:things, :item])
    
    paths = TestPaths.new(@resource)
    paths.list("curtains").should == "/curtains"
    paths.show("curtains", "red5").should == "/curtains/red5"
  end
  
  it "can mix it up" do
    TestPaths.path_method(:show_curtain, ["curtains", :item])
    TestPaths.path_method(:show_curtain_rings, ["curtains", :item, "rings" ])
    
    paths = TestPaths.new(@resource)
    paths.show_curtain("blue1").should == "/curtains/blue1"
    paths.show_curtain_rings("blue1").should == "/curtains/blue1/rings"
  end
  
end
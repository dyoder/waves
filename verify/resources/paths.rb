# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

describe "A Paths class" do
  
  before do
    class TestPaths < Waves::Mapping::Paths
    end
    @resource = mock(:resource)
  end
  
  it "can define named paths using strings" do
    TestPaths.define_path(:foo, ["foo"])
    TestPaths.define_path(:bar, ["bar", "baz"])
    
    TestPaths.new(@resource).foo.should == "/foo"
    TestPaths.new(@resource).bar.should == "/bar/baz"
  end
  
  it "can define named paths using symbols as placeholders" do
    TestPaths.define_path(:list, [:things])
    TestPaths.define_path(:show, [:things, :item])
    
    paths = TestPaths.new(@resource)
    paths.list("curtains").should == "/curtains"
    paths.show("curtains", "red5").should == "/curtains/red5"
  end
  
  it "can mix it up" do
    TestPaths.define_path(:show_curtain, ["curtains", :item])
    TestPaths.define_path(:show_curtain_rings, ["curtains", :item, "rings" ])
    
    paths = TestPaths.new(@resource)
    paths.show_curtain("blue1").should == "/curtains/blue1"
    paths.show_curtain_rings("blue1").should == "/curtains/blue1/rings"
  end
  
end

describe "A path generating method" do
  
  before do
    class TestPaths < Waves::Mapping::Paths; end
    @resource = mock(:resource)
    TestPaths.define_path(:list, [:things])
  end
  
  it "can take a hash to supply query params" do
    paths = TestPaths.new(@resource)
    paths.list(:curtains, :mode => "sort").should == "/curtains?mode=sort"
  end
  
end
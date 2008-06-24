# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")
require "#{UTILITIES}/hash"

describe "The monkeypatch to Hash" do
  
  it "provides a non-destructive method for converting all hash keys to strings" do
    h = { :a => 1, 'b' => 2, 3 => 3}
    h.stringify_keys.should == { 'a' => 1, 'b' => 2, '3' => 3}
    h.should == { :a => 1, 'b' => 2, 3 => 3}
  end
  
  it "provides a destructive method for converting hash keys to symbols" do
    h = { "two" => 2, :three => 3}
    h.symbolize_keys!
    h.should == { :two => 2, :three => 3 }
  end
  
end
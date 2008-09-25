# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

module Waves
  def synchronize; @mutex ||= Mutex.new; end
end

describe "An instance of Waves::Cache::IPI" do

  before do
    @cache = Waves::Cache::IPI.new
  end
  
  it "can store and retrieve a value using a key" do
    @cache[:key1] = "value1"
    @cache[:key1].should == "value1" 
  end
  
  feature "can retrieve multiple items" do
    @cache[:a], @cache[:b], @cache[:c] = 1, 2, 3
    @cache.values_at( :a, :b )
  end

  it "can set a time-to-live in seconds for an item" do
    @cache[:a], @cache[:b], @cache[:c] = 1, 2, 3
    @cache.store(:key1,"value3", 0.01)
    @cache.store(:key2,"value3", 0.03)
    sleep( 0.02 )
    @cache.exists?(:key1).should == false     
    @cache.exists?(:key2).should == true
    
    lambda { @cache.store(:a, :b, "3") }.should.raise TypeError
  end
  
  it "can delete a value from the cache" do
    @cache[:a], @cache[:b], @cache[:c] = 1, 2, 3
    @cache[:key1] = "value0"
    @cache.delete( :key1 )
    @cache.exists?( :key1 ).should == false
  end
  
  it "can delete multiple values from the cache" do
    @cache[:a], @cache[:b], @cache[:c] = 1, 2, 3
    @cache[:key1], @cache[:key2] = "value1", "value2"
    @cache.delete :key1, :key2
    @cache.exists?(:key1).should == false
    @cache.exists?(:key2).should == false
  end
  
  it "can clear the cache" do
    @cache[:a], @cache[:b], @cache[:c] = 1, 2, 3
    @cache[:key1], @cache[:key2] = "value1", "value2"
    @cache.clear
    @cache.exists?(:key1).should == false
    @cache.exists?(:key2).should == false
  end

end

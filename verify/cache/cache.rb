# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

Waves::Console.load( :mode => 'development', :startup => "#{File.dirname(__FILE__)}/../../app/startup.rb")

describe "An instance of Waves::Cache::IPI" do

  before do
    @cache = Waves::Cache::IPI.new
  end
  
  it "can store and retrieve a value using a key" do
    threads =[]; 5.times do 
    threads << Thread.new do 
      @cache[:key1] = "value1"
      @cache[:key1].should == "value1" 
    end; end
    threads.each {|t| t.run; t.join }
  end
  
  feature "can retrieve multiple items" do
    threads =[]; 5.times do 
    threads << Thread.new do 
      Thread.stop
      @cache[:a], @cache[:b], @cache[:c] = 1, 2, 3
      @cache.values_at( :a, :b )
    end; end
    threads.each {|t| t.run; t.join }
  end

  it "can set a time-to-live in seconds for an item" do
    threads =[]; 5.times do 
    threads << Thread.new do 
      Thread.stop
      @cache[:a], @cache[:b], @cache[:c] = 1, 2, 3
      @cache.store(:key1,"value3", 0.01)
      @cache.store(:key2,"value3", 0.03)
      sleep( 0.02 )
      @cache.exists?(:key1).should == false     
      @cache.exists?(:key2).should == true
    end; end
    threads.each {|t| t.run; t.join }
    
    lambda { @cache.store(:a, :b, "3") }.should.raise TypeError
  end
  
  it "can delete a value from the cache" do
    threads =[]; 5.times do 
    threads << Thread.new do 
      Thread.stop
      @cache[:a], @cache[:b], @cache[:c] = 1, 2, 3
      @cache[:key1] = "value0"
      @cache.delete( :key1 )
      @cache.exists?( :key1 ).should == false
    end; end
    threads.each {|t| t.run; t.join }
  end
  
  it "can delete multiple values from the cache" do
    threads =[]; 5.times do 
    threads << Thread.new do 
      Thread.stop
      @cache[:a], @cache[:b], @cache[:c] = 1, 2, 3
      @cache[:key1], @cache[:key2] = "value1", "value2"
      @cache.delete :key1, :key2
      @cache.exists?(:key1).should == false
      @cache.exists?(:key2).should == false
    end; end
    threads.each {|t| t.run; t.join }
  end
  
  it "can clear the cache" do
    threads =[]; 5.times do 
    threads << Thread.new do 
      Thread.stop
      @cache[:a], @cache[:b], @cache[:c] = 1, 2, 3
      @cache[:key1], @cache[:key2] = "value1", "value2"
      @cache.clear
      @cache.exists?(:key1).should == false
      @cache.exists?(:key2).should == false
    end; end
    threads.each {|t| t.run; t.join }
  end

end

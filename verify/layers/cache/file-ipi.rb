require File.join(File.dirname(__FILE__) , "helpers")

require 'cache/cache'
require 'layers/cache/file/file-ipi'

module Waves
 def synchronize; @mutex ||= Mutex.new; end
end

describe "Waves::Cache::File" do

  before do
    FileUtils.mkdir '/tmp/waves_cache' unless File.exist?('/tmp/waves_cache')
    @cache = Waves::Cache::File.new :dir => '/tmp/waves_cache' 
  end

  after do
    FileUtils.rm_rf '/tmp/waves_cache'
  end
  
  it "can find a value in the cache" do
    @cache[:a] = 1
    @cache[:a].should == 1
  end

  it "can delete (multiple) values from the cache" do
    @cache[:a] = 1
    @cache[:a].should == 1
    @cache[:b] = 2
    @cache.delete :a, :b
    #@cache.exists?(:a).should == "false"
    lambda { @cache[:b] }.should.raise Waves::Cache::KeyMissing
  end


  it "can set a time-to-live in seconds for an item" do
    @cache[:a], @cache[:b], @cache[:c] = 1, 2, 3
    @cache.store(:key1,"value3", 0.01)
    @cache.store(:key2,"value3", 0.03)
    sleep( 0.02 )
    @cache.exists?(:key1).should == false     
    @cache.exists?(:key2).should == true
    
    #lambda { @cache.store(:a, :b, "3") }.should.raise TypeError
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

  it "can synchronize" do
    @cache[:a] = 0
    threads=[]
    90.times do |x| 
      threads << Thread.new do
        Thread.stop; sleep rand / 100
        @cache[:a] = @cache[:a] + 1 
      end
    end
    threads.each {|thread| thread.run; thread.join }
    @cache[:a].should == 90
  end
  
end

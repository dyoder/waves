require File.join(File.dirname(__FILE__) , "helpers")

require 'utilities/string'

require 'cache/cache'
describe "Waves::Cache" do
  def fill_cache
    cache = Waves::Cache.new
    cache[:key1] = "value1"
    cache[:key2] = "value2"
    cache
  end

  it "can find a value in the cache" do
    @cache = fill_cache
    @cache[:key1].should == "value1"
    @cache.clear
  end

  it "can delete a value from the cache" do
    @cache = fill_cache
    @cache.delete :key1
    @cache[:key1].should == nil
    @cache[:key2].should =="value2"
    @cache.clear
  end

  it "can delete multiple values from the cache" do
    @cache = fill_cache
    @cache.delete [:key1, :key2]
    @cache[:key1].should == nil
    @cache[:key2].should == nil
  end
  
  it "can clear the cache" do
    @cache = fill_cache
    @cache.clear
    @cache[:key1].should == nil
    @cache[:key2].should == nil
  end

end

require 'layers/cache/file_cache'
describe "Waves::Layers::FileCache" do

  def fill_cache
    cache = Waves::Cache.new
    cache[:key1] = "value1"
    cache[:key2] = "value2"
    cache
  end

  it "can find a value in the cache" do
    fill_cache
    @cache[:key1][:value].should == "value1"
    @cache.clear
  end

  it "can delete a value from the cache" do
    @cache = fill_cache
    @cache.delete :key1
    @cache[:key1].should == nil
    @cache[:key2][:value].should == "value2"
    @cache.clear
  end

  it "can delete multiple values from the cache" do
    @cache = fill_cache
    @cache.delete [:key1, :key2]
    @cache[:key1].should == nil
    @cache[:key2].should == nil
    @cache.clear
  end

  it "can clear the cache" do
    @cache = fill_cache
    @cache.clear
    @cache[:key1].should == nil
    @cache[:key2].should == nil
    File.exist?(__FILE__ / 'key1').should == nil
  end

end
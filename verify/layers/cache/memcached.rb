require File.join(File.dirname(__FILE__) , "helpers")
include Cache::Helpers

Waves::Console.load
Waves.config.cache :servers => 'localhost:11211'

require 'layers/cache/memcached'
include Waves::Layers::Cache::Memcached

describe "Waves::Layers::Cache::Memcached" do

  before do
    #Wavescache = Waves::Layers::Cache::Memcached.new(:servers => 'localhost:11211')
    fill_cache 
  end
  
  it "can find a value in the cache" do
    Waves.cache[:key1].should == "value1"
  end

  it "can delete a value from the cache" do
    delete_test 
  end

  it "can delete multiple values from the cache" do
    multi_delete_test 
  end

  it "has members who obey their time-to-live" do
    ttl_test_integer   # memcached will not allow floats for time-to-live
  end
  
  it "can clear the cache" do
    clear_test 
  end

end
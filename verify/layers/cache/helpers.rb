

module Cache
  module Helpers

    def fill_cache
      Waves.cache.clear
      Waves.cache[:key1] = "value1"
      Waves.cache[:key2] = "value2"
    end

    def ttl_test
      Waves.cache.store(:key3,"value3", 0.01)
      Waves.cache[:key3].should == "value3"
      sleep 0.02  # if Memcached layer is failing this test, try increasing the sleep time
      Waves.cache.exists?(:key3).should == false
    end
    
    def ttl_test_integer
      Waves.cache.store(:key3,"value3", 1)
      Waves.cache[:key3].should == "value3"
      sleep 2  # if Memcached layer is failing this test, try increasing the sleep time
      Waves.cache.exists?(:key3).should == false
    end

    def delete_test
      fill_cache
      Waves.cache.delete :key1
      Waves.cache.exists?(:key1).should == false
      Waves.cache[:key2].should =="value2"
    end

    def multi_delete_test
      fill_cache
      Waves.cache.delete :key1, :key2
      Waves.cache.exists?(:key1).should == false
      Waves.cache.exists?(:key2).should == false
    end

    def clear_test
      fill_cache
      Waves.cache.clear
      Waves.cache.exists?(:key1).should == false
      Waves.cache.exists?(:key2).should == false
    end
  end
end
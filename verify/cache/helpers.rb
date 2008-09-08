# Helpers for testing cache


module Cache
  module Helpers

    def fill_cache(cache)
      cache.clear
      cache[:key1] = "value1"
      cache[:key2] = "value2"
      return cache
    end

    def ttl_test(cache)
      cache.store(:key3,"value3", 0.01)
      cache[:key3].should == "value3"
      sleep 0.02
      cache.exists?(:key3).should == false
    end

    def delete_test(cache)
      fill_cache cache
      cache.delete :key1
      cache.exists?(:key1).should == false
      cache[:key2].should =="value2"
    end

    def multi_delete_test(cache)
      fill_cache cache
      cache.delete :key1, :key2
      cache.exists?(:key1).should == false
      cache.exists?(:key2).should == false
    end

    def clear_test(cache)
      fill_cache cache
      cache.clear
      cache.exists?(:key1).should == false
      cache.exists?(:key2).should == false
    end
  end
end
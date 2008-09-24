require File.join(File.dirname(__FILE__) , "helpers")

require 'cache/cache'
require 'layers/cache/file'
include Cache::Helpers

# Helpers for testing cache
clear_all_apps
module Waves
  def cache(init=nil)
    if init.nil?
      @cache
    else

    end
  end
end

module TestApplication
  include AutoCode
  module Configurations
    class Development
      stub!(:cache).and_return(:dir => '/tmp')
    end
  end
  
  include Waves::Layers::Cache::FileCache
end



Waves.stub!(:config).and_return(TestApplication::Configurations::Development)

Waves << TestApplication

TA = TestApplication


describe "Waves::Layers::Cache::FileCache" do

  before do
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
    ttl_test 
  end
  
  it "can clear the cache" do
    clear_test 
  end

end
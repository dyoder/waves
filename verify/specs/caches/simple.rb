require "#{File.dirname(__FILE__)}/helpers"
require 'foundations/compact'
require 'caches/simple'

module SimpleApp ; include Waves::Foundations::Compact ; end

describe "Waves.cache" do
  it "Takes a cache object as its argument" do
    Waves.cache Waves::Caches::Simple.new
  end
end

describe "Waves::Caches::Simple" do
  it "can store and fetch, including implementation-wide methods" do
    Waves.cache.store :frog, "hopping"
    Waves.cache[:ball] = "dropping"
        
    Waves.cache[:frog].should.==("hopping") and Waves.cache.fetch(:ball).should.==("dropping")
  end

  it "can delete and clear" do
    Waves.cache.delete :frog
    Waves.cache.fetch(:frog).should == nil
    
    Waves.cache.store :gravy, "bowl"
    Waves.cache.fetch(:gravy).should.not.==(nil) and Waves.cache[:ball].should.not.==(nil)
    
    Waves.cache.clear   
    Waves.cache.fetch(:frog).should.==(nil) and Waves.cache[:ball].should.==(nil)
  end
end

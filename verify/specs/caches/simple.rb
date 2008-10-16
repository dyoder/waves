require "#{File.dirname(__FILE__)}/helpers"
require 'foundations/compact'
require 'caches/simple'

module SimpleApp ; include Waves::Foundations::Compact ; end

describe "can assign a Waves::Caches::Simple object to Waves.cache" do
  module SimpleApp
    Waves.cache Waves::Caches::Simple.new
  end
end

describe "can store and fetch, including implementation-wide methods" do
  module SimpleApp
    Waves.cache.store :frog, "hopping"
    Waves.cache[:ball] = "dropping"
        
    Waves.cache[:frog].should.==("hopping") and Waves.cache.fetch(:ball).should.==("dropping")
  end
end

describe "can delete and clear" do
  module SimpleApp
    Waves.cache.delete :frog
    Waves.cache.fetch(:frog).should == nil
    
    Waves.cache.store :gravy, "bowl"
    Waves.cache.fetch(:gravy).should.not.==(nil) and Waves.cache[:ball].should.not.==(nil)
    
    Waves.cache.clear   
    Waves.cache.fetch(:frog).should.==(nil) and Waves.cache[:ball].should.==(nil)
  end
end

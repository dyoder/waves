require "#{File.dirname(__FILE__)}/helpers"

require 'foundations/compact'
require 'caches/file'

module SimpleApp ; include Waves::Foundations::Compact ; end

describe "can assign a Waves::Caches::File object to Waves.cache" do
  module SimpleApp
    
    Waves.cache Waves::Caches::File.new( :directory => '/tmp/testeroni') 
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
    
    %w( :frog, :ball, :gravy, 'giving' ).each do |key|
      File.exist?('/tmp/testeroni' + key).should == nil
    end
  end
end
    
    
    
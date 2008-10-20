require "#{File.dirname(__FILE__)}/helpers"

require 'foundations/compact'
require 'caches/file'

module SimpleApp ; include Waves::Foundations::Compact ; end

describe "Waves::Caches::File" do
  
  before do
    @cache = Waves::Caches::File.new( :directory => '/tmp') 
  end
  
  it "can store and fetch, including implementation-wide methods" do
    @cache.store :frog, "hopping"
    @cache[:ball] = "dropping"
        
    @cache[:frog].should.==("hopping")
    @cache.fetch(:ball).should.==("dropping")
  end

  it "can delete and clear" do
    @cache.store :frog, "hopping"
    @cache.delete :frog
    @cache.fetch(:frog).should == nil
    
    @cache.delete(:monkey)
    
    @cache.store :gravy, "bowl"
    @cache.fetch(:gravy).should.not.==(nil) and @cache[:ball].should.not.==(nil)
    
    @cache.clear   
    @cache.fetch(:frog).should.==(nil) and @cache[:ball].should.==(nil)
    
    %w( :frog, :ball, :gravy, 'giving' ).each do |key|
      File.exist?('/tmp/testeroni' + key).should == false
    end
  end
end
    
    
    
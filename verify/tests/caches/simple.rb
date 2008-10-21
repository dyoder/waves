# require 'test_helper' because RubyMate needs help
require "#{File.dirname(__FILE__)}/helpers"
require 'foundations/compact'
require 'caches/simple'

module SimpleApp ; include Waves::Foundations::Compact ; end

describe "Waves::Caches::Simple" do
  
  before do
    @cache = Waves::Caches::Simple.new
  end
  
  it "can store and fetch, including implementation-wide methods" do
    @cache.store :frog, "hopping"
    @cache[:ball] = "dropping"
        
    @cache[:frog].should.==("hopping") and @cache.fetch(:ball).should.==("dropping")
  end

  it "can delete and clear" do
    @cache.delete :frog
    @cache.fetch(:frog).should == nil
    
    @cache.store :gravy, "bowl"
    @cache.fetch(:gravy).should.not.==(nil) and @cache[:ball].should.not.==(nil)
    
    @cache.clear   
    @cache.fetch(:frog).should.==(nil) and @cache[:ball].should.==(nil)
  end
end

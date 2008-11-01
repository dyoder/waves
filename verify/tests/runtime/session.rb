require 'verify/helpers.rb'
require 'autocode'
require 'foundations/compact'
include Waves::Mocks

describe "Specing Waves::Session object" do
  before do
    Test = Module.new { include Waves::Foundations::Compact }
    Waves << Test
    DEFAULT_ENV['rack.session'] = { }
    @waves_request = Waves::Request.new(DEFAULT_ENV)
  end

  after do
    Waves.applications.clear
    Object.instance_eval { remove_const( :Test ) if const_defined?( :Test ) }
  end
  
  feature "Session object should exist" do
    @waves_request.should.respond_to?(:session)
    @waves_request.session.class.should == Waves::Session
    @waves_request.session['doesnotexist'].should == nil
  end
  
  feature "Should be able to store value in session and retrieve it" do
    @waves_request.session['nick'] = 'CRZYBEAR'
    #This should actually be tested after a round trip?
    @waves_request.session['nick'].should == 'CRZYBEAR'
  end
  
end

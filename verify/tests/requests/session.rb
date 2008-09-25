# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

SessionData = "--- \nmoo: cow\n"



describe "An new instance of Waves::Session" do

  
  before do
    FileUtils.mkdir(BasePath) unless File.exist?(BasePath)
    Waves::Session.stub!(:generate_session_id).and_return("fake_session")
    Waves::Session.stub!(:base_path).and_return(BasePath)
  end
  
  after do
    FileUtils.rm Dir["#{BasePath}/fake_session"]
    FileUtils.rmdir BasePath
  end
  
  it "loads data from a session file if one exists" do
    File.write(BasePath / :fake_session, SessionData)
    @request = Waves::Request.new(env_for)
    session = @request.session
    session.to_hash.should == { 'moo' => 'cow'}
  end
  
  it "is empty when no session file exists" do
    Waves::Session.stub!(:generate_session_id).and_return("other_session")
    @request = Waves::Request.new(env_for)
    session = @request.session
    session.to_hash.should.be.empty
  end
  
end

describe "Session values" do
  
  before do
    Waves::Session.stub!(:base_path).and_return(BasePath)
    @request = Waves::Request.new(env_for)
  end
  
  it "can be read and written using [] and []=" do
    session = Waves::Session.new(@request)
    session['moo'].should.be.nil
    session['moo'] = 'bull'
    session['moo'].should == 'bull'
  end
  
end



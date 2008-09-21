# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

describe "#accept, #accept_charset, and #accept_language" do
  
  before do
    Waves::Session.stub!(:base_path).and_return(BasePath)
    @request = Waves::Request.new(env_for("/", 
      'HTTP_ACCEPT' => 'text/xml,application/xhtml+xml;q=0.9, text/plain ;q=0.8,image/png,audio/*;q=0.5,*/foo',
      'HTTP_ACCEPT_CHARSET' => 'ISO-8859-1,utf-8;q=0.7;q=0.7',
      'HTTP_ACCEPT_LANGUAGE' => 'en-us,en;q=0.5'
      ))
  end
  
  it "evaluates to an array of entries" do
    entries = ["text/xml", "application/xhtml+xml", "text/plain", "image/png", "audio/*", "*/foo"]
    @request.accept.should == entries
    
    charsets = [ "ISO-8859-1", "utf-8" ]
    @request.accept_charset.should == charsets
    
    languages = [ "en-us", "en" ]
    @request.accept_language.should == languages
  end
  
  it "matches using === or =~" do
    (@request.accept === "text/xml").should == true
    (@request.accept =~ /xml/).should == true
    (@request.accept === "text/bogus").should == false
    
    (@request.accept_charset === "utf-8").should == true
    (@request.accept_charset =~ /utf/).should == true
    (@request.accept_charset === "utf-16").should == false
    
    (@request.accept_language =~ "en-us").should == true
    (@request.accept_language =~ /en/ ).should == true
    (@request.accept_language =~ /ru/ ).should == false
    (@request.accept_language === "en-us").should == true
    (@request.accept_language =~ "ru").should == false
  end
  
  it "handles the * wildcard appropriately" do
    (@request.accept === "audio/wav").should == true
    (@request.accept === "flip/wav").should == false
    (@request.accept === /mork/).should == false
    (@request.accept === "bar/foo").should == true
    (@request.accept === "bar/baz").should == false
  end
  
end